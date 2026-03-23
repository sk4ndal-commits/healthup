using Application.Interfaces;
using FluentAssertions;
using Hangfire;
using Hangfire.InMemory;
using Infrastructure.Persistence;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Options;
using NSubstitute;

namespace Api.Tests;

public class HealthEndpointTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public HealthEndpointTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.WithWebHostBuilder(builder =>
        {
            builder.ConfigureServices(services =>
            {
                // Replace real DB with InMemory (EF Core 10: must remove all provider registrations)
                var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<AppDbContext>));
                if (descriptor != null) services.Remove(descriptor);
                // Remove all IDbContextOptionsConfiguration registrations to avoid dual-provider conflict
                var optionConfigs = services
                    .Where(d => d.ServiceType.IsGenericType &&
                                d.ServiceType.GetGenericTypeDefinition() == typeof(IDbContextOptionsConfiguration<>))
                    .ToList();
                foreach (var d in optionConfigs) services.Remove(d);
                services.RemoveAll<AppDbContext>();
                services.AddDbContext<AppDbContext>(options =>
                    options.UseInMemoryDatabase("ApiTestDb"));

                // Replace Hangfire PostgreSQL storage with InMemory to avoid DB connection at startup
                services.RemoveAll<JobStorage>();
                services.AddHangfire(config => config.UseInMemoryStorage());

                // Remove all health check registrations (NpgSql/DbContext) that require a live PostgreSQL
                // connection. In .NET 10 checks are registered via IConfigureOptions<HealthCheckServiceOptions>
                // so we must remove both HealthCheckRegistration and IConfigureOptions descriptors.
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

    [Fact]
    public async Task Get_Health_ReturnsOk()
    {
        var response = await _client.GetAsync("/api/v1/health");

        response.StatusCode.Should().Be(System.Net.HttpStatusCode.OK);
    }

    [Fact]
    public async Task Get_Todos_WithoutAuth_ReturnsUnauthorized()
    {
        var response = await _client.GetAsync("/api/v1/todo");

        response.StatusCode.Should().Be(System.Net.HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task Post_Login_WithInvalidCredentials_ReturnsBadRequest()
    {
        var payload = new StringContent(
            """{"email":"nobody@example.com","password":"wrong"}""",
            System.Text.Encoding.UTF8,
            "application/json");

        var response = await _client.PostAsync("/api/v1/auth/login", payload);

        response.StatusCode.Should().BeOneOf(
            System.Net.HttpStatusCode.BadRequest,
            System.Net.HttpStatusCode.Unauthorized);
    }
}
