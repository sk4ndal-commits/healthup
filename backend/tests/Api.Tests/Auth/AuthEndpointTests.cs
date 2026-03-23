using System.Net;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using Application.Interfaces;
using FluentAssertions;
using Hangfire;
using Hangfire.InMemory;
using Infrastructure.Persistence;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Options;
using NSubstitute;

namespace Api.Tests.Auth;

public class AuthEndpointTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public AuthEndpointTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureAppConfiguration((_, cfg) =>
            {
                cfg.AddInMemoryCollection(new Dictionary<string, string?>
                {
                    ["FeatureManagement:TenantSelfServiceRegistration"] = "true"
                });
            });

            builder.ConfigureServices(services =>
            {
                // Replace real DB with InMemory
                var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<AppDbContext>));
                if (descriptor != null) services.Remove(descriptor);
                var optionConfigs = services
                    .Where(d => d.ServiceType.IsGenericType &&
                                d.ServiceType.GetGenericTypeDefinition() == typeof(IDbContextOptionsConfiguration<>))
                    .ToList();
                foreach (var d in optionConfigs) services.Remove(d);
                services.RemoveAll<AppDbContext>();
                services.AddDbContext<AppDbContext>(options =>
                    options.UseInMemoryDatabase("AuthIntegrationTestDb")
                           .ConfigureWarnings(w => w.Ignore(InMemoryEventId.TransactionIgnoredWarning)));

                // Replace Hangfire PostgreSQL storage with InMemory
                services.RemoveAll<JobStorage>();
                services.AddHangfire(config => config.UseInMemoryStorage());

                // Remove health checks requiring live PostgreSQL
                var hcRegistrations = services
                    .Where(d => d.ServiceType == typeof(HealthCheckRegistration))
                    .ToList();
                foreach (var d in hcRegistrations) services.Remove(d);
                var hcOptions = services
                    .Where(d => d.ServiceType == typeof(IConfigureOptions<HealthCheckServiceOptions>))
                    .ToList();
                foreach (var d in hcOptions) services.Remove(d);

                // Stub ICurrentUserService
                var currentUser = Substitute.For<ICurrentUserService>();
                currentUser.AccountId.Returns(0);
                services.RemoveAll<ICurrentUserService>();
                services.AddSingleton(currentUser);
            });
        }).CreateClient();
    }

    private static StringContent Json(object payload) =>
        new(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");

    // --- POST /api/v1/auth/register ---

    [Fact]
    public async Task Register_ShouldReturn200_WhenPayloadIsValid()
    {
        var response = await _client.PostAsync("/api/v1/auth/register", Json(new
        {
            email = $"newuser_{Guid.NewGuid():N}@test.com",
            password = "Password123!",
            accountName = "Test Org"
        }));

        response.StatusCode.Should().Be(HttpStatusCode.OK);
    }

    [Fact]
    public async Task Register_ShouldReturn400_WhenBodyIsNotJson()
    {
        var response = await _client.PostAsync("/api/v1/auth/register",
            new StringContent("not-json", Encoding.UTF8, "application/json"));

        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    [Fact]
    public async Task Register_ShouldReturn409_WhenEmailIsAlreadyTaken()
    {
        var email = $"duplicate_{Guid.NewGuid():N}@test.com";

        await _client.PostAsync("/api/v1/auth/register", Json(new
        {
            email,
            password = "Password123!",
            accountName = "First Org"
        }));

        var response = await _client.PostAsync("/api/v1/auth/register", Json(new
        {
            email,
            password = "Password123!",
            accountName = "Second Org"
        }));

        response.StatusCode.Should().Be(HttpStatusCode.Conflict);
    }

    // --- POST /api/v1/auth/login ---

    [Fact]
    public async Task Login_ShouldReturn200WithToken_WhenCredentialsAreValid()
    {
        var email = $"logintest_{Guid.NewGuid():N}@test.com";
        await _client.PostAsync("/api/v1/auth/register", Json(new
        {
            email,
            password = "Password123!",
            accountName = "Login Org"
        }));

        var response = await _client.PostAsync("/api/v1/auth/login", Json(new
        {
            email,
            password = "Password123!"
        }));

        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var body = await response.Content.ReadFromJsonAsync<JsonElement>();
        body.GetProperty("accessToken").GetString().Should().NotBeNullOrEmpty();
    }

    [Fact]
    public async Task Login_ShouldReturn401_WhenPasswordIsWrong()
    {
        var email = $"wrongpw_{Guid.NewGuid():N}@test.com";
        await _client.PostAsync("/api/v1/auth/register", Json(new
        {
            email,
            password = "Password123!",
            accountName = "Org"
        }));

        var response = await _client.PostAsync("/api/v1/auth/login", Json(new
        {
            email,
            password = "WrongPassword!"
        }));

        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    // --- POST /api/v1/auth/refresh ---

    [Fact]
    public async Task Refresh_ShouldReturn200WithNewTokens_WhenRefreshTokenIsValid()
    {
        var email = $"refresh_{Guid.NewGuid():N}@test.com";
        await _client.PostAsync("/api/v1/auth/register", Json(new
        {
            email,
            password = "Password123!",
            accountName = "Refresh Org"
        }));

        var loginResponse = await _client.PostAsync("/api/v1/auth/login", Json(new
        {
            email,
            password = "Password123!"
        }));
        var loginBody = await loginResponse.Content.ReadFromJsonAsync<JsonElement>();
        var refreshToken = loginBody.GetProperty("refreshToken").GetString();

        var response = await _client.PostAsync("/api/v1/auth/refresh", Json(new
        {
            refreshToken
        }));

        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var body = await response.Content.ReadFromJsonAsync<JsonElement>();
        body.GetProperty("accessToken").GetString().Should().NotBeNullOrEmpty();
    }

    [Fact]
    public async Task Refresh_ShouldReturn401_WhenRefreshTokenIsInvalid()
    {
        var response = await _client.PostAsync("/api/v1/auth/refresh", Json(new
        {
            refreshToken = "totally-invalid-token"
        }));

        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    // --- GET /api/v1/admin/users ---

    [Fact]
    public async Task AdminUsers_ShouldReturn401_WhenNoJwtProvided()
    {
        var response = await _client.GetAsync("/api/v1/admin/users");

        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task AdminUsers_ShouldReturn403_WhenCalledWithRegularUserJwt()
    {
        var email = $"regularuser_{Guid.NewGuid():N}@test.com";
        await _client.PostAsync("/api/v1/auth/register", Json(new
        {
            email,
            password = "Password123!",
            accountName = "User Org"
        }));

        var loginResponse = await _client.PostAsync("/api/v1/auth/login", Json(new
        {
            email,
            password = "Password123!"
        }));
        var loginBody = await loginResponse.Content.ReadFromJsonAsync<JsonElement>();
        var accessToken = loginBody.GetProperty("accessToken").GetString();

        var request = new HttpRequestMessage(HttpMethod.Get, "/api/v1/admin/users");
        request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", accessToken);

        var response = await _client.SendAsync(request);

        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }
}
