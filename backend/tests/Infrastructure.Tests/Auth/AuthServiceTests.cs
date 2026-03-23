using Application.Interfaces;
using Domain;
using FluentAssertions;
using Infrastructure.Auth;
using Infrastructure.Persistence;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.Extensions.Configuration;
using NSubstitute;

namespace Infrastructure.Tests.Auth;

public class AuthServiceTests : IDisposable
{
    private readonly AppDbContext _context;
    private readonly IAuditService _auditService = Substitute.For<IAuditService>();
    private readonly IPasswordHasher<User> _passwordHasher = new PasswordHasher<User>();
    private readonly IConfiguration _configuration;
    private readonly AuthenticationService _sut;
    private readonly IdentityService _identity;

    public AuthServiceTests()
    {
        var currentUser = Substitute.For<ICurrentUserService>();
        currentUser.AccountId.Returns(0);

        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .ConfigureWarnings(w => w.Ignore(InMemoryEventId.TransactionIgnoredWarning))
            .Options;

        _context = new AppDbContext(options, currentUser);

        var configData = new Dictionary<string, string?>
        {
            ["JwtSettings:Secret"] = "super-secret-key-for-testing-purposes-only-32chars",
            ["JwtSettings:Issuer"] = "test-issuer",
            ["JwtSettings:Audience"] = "test-audience",
            ["JwtSettings:ExpirationMinutes"] = "60",
            ["JwtSettings:RefreshExpirationDays"] = "30"
        };
        _configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(configData)
            .Build();

        _sut = new AuthenticationService(_context, _configuration, _auditService, _passwordHasher);
        _identity = new IdentityService(_context, _auditService, _passwordHasher);
    }

    public void Dispose() => _context.Dispose();

    private async Task<(Account account, User user)> SeedUserAsync(string email = "user@test.com", string password = "Password123!", bool isActive = true)
    {
        var account = new Account { Name = "Test Account", CreatedAtUtc = DateTime.UtcNow };
        _context.Accounts.Add(account);
        await _context.SaveChangesAsync();

        var user = new User
        {
            Email = email,
            Role = "User",
            IsActive = isActive,
            AccountId = account.Id,
            CreatedAtUtc = DateTime.UtcNow
        };
        user.PasswordHash = _passwordHasher.HashPassword(user, password);
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return (account, user);
    }

    // --- LoginAsync ---

    [Fact]
    public async Task LoginAsync_ShouldReturnTokens_WhenCredentialsAreValid()
    {
        await SeedUserAsync("login@test.com", "Password123!");

        var result = await _sut.LoginAsync("login@test.com", "Password123!");

        result.Should().NotBeNull();
        result!.Value.AccessToken.Should().NotBeNullOrEmpty();
        result.Value.RefreshToken.Should().NotBeNullOrEmpty();
        result.Value.ExpiresInSeconds.Should().BeGreaterThan(0);
    }

    [Fact]
    public async Task LoginAsync_ShouldReturnNull_WhenPasswordIsWrong()
    {
        await SeedUserAsync("login@test.com", "Password123!");

        var result = await _sut.LoginAsync("login@test.com", "WrongPassword!");

        result.Should().BeNull();
    }

    [Fact]
    public async Task LoginAsync_ShouldReturnNull_WhenUserIsInactive()
    {
        await SeedUserAsync("inactive@test.com", "Password123!", isActive: false);

        var result = await _sut.LoginAsync("inactive@test.com", "Password123!");

        result.Should().BeNull();
    }

    // --- RegisterAsync ---

    [Fact]
    public async Task RegisterAsync_ShouldCreateAccountAndUser_WhenEmailIsNew()
    {
        var result = await _identity.RegisterAsync("new@test.com", "Password123!", "New Org");

        result.Should().BeTrue();
        _context.Users.IgnoreQueryFilters().Should().ContainSingle(u => u.Email == "new@test.com");
        _context.Accounts.Should().ContainSingle(a => a.Name == "New Org");
    }

    [Fact]
    public async Task RegisterAsync_ShouldReturnFalse_WhenEmailAlreadyExists()
    {
        await SeedUserAsync("existing@test.com");

        var result = await _identity.RegisterAsync("existing@test.com", "Password123!", "Another Org");

        result.Should().BeFalse();
    }

    // --- RefreshTokenAsync ---

    [Fact]
    public async Task RefreshTokenAsync_ShouldReturnNewTokens_AndRevokeOldToken()
    {
        var loginResult = await _sut.LoginAsync(
            (await SeedUserAsync("refresh@test.com") is var (_, u) ? u.Email : ""),
            "Password123!");
        var oldRefreshToken = loginResult!.Value.RefreshToken;

        var result = await _sut.RefreshTokenAsync(oldRefreshToken);

        result.Should().NotBeNull();
        result!.Value.RefreshToken.Should().NotBe(oldRefreshToken);

        var oldRecord = await _context.RefreshTokens.IgnoreQueryFilters()
            .FirstOrDefaultAsync(t => t.Token == oldRefreshToken);
        oldRecord!.RevokedAtUtc.Should().NotBeNull();
    }

    [Fact]
    public async Task RefreshTokenAsync_ShouldReturnNull_WhenTokenIsInvalid()
    {
        var result = await _sut.RefreshTokenAsync("invalid-token-that-does-not-exist");

        result.Should().BeNull();
    }

    [Fact]
    public async Task RefreshTokenAsync_ShouldReturnNull_WhenTokenIsRevoked()
    {
        var loginResult = await _sut.LoginAsync(
            (await SeedUserAsync("revoked@test.com") is var (_, u) ? u.Email : ""),
            "Password123!");
        var refreshToken = loginResult!.Value.RefreshToken;

        // Revoke the token manually
        var record = await _context.RefreshTokens.IgnoreQueryFilters()
            .FirstAsync(t => t.Token == refreshToken);
        record.RevokedAtUtc = DateTime.UtcNow;
        await _context.SaveChangesAsync();

        var result = await _sut.RefreshTokenAsync(refreshToken);

        result.Should().BeNull();
    }

    // --- GeneratePasswordResetTokenAsync ---

    [Fact]
    public async Task GeneratePasswordResetTokenAsync_ShouldReturnToken_WhenEmailExists()
    {
        await SeedUserAsync("reset@test.com");

        var token = await _identity.GeneratePasswordResetTokenAsync("reset@test.com");

        token.Should().NotBeNullOrEmpty();
        var user = await _context.Users.IgnoreQueryFilters().FirstAsync(u => u.Email == "reset@test.com");
        user.PasswordResetToken.Should().Be(token);
        user.PasswordResetTokenExpiresUtc.Should().BeAfter(DateTime.UtcNow);
    }

    [Fact]
    public async Task GeneratePasswordResetTokenAsync_ShouldReturnNull_WhenEmailNotFound()
    {
        var token = await _identity.GeneratePasswordResetTokenAsync("nobody@test.com");

        token.Should().BeNull();
    }

    // --- ResetPasswordWithTokenAsync ---

    [Fact]
    public async Task ResetPasswordWithTokenAsync_ShouldChangePassword_WhenTokenIsValid()
    {
        await SeedUserAsync("tokenreset@test.com", "OldPassword123!");
        var token = await _identity.GeneratePasswordResetTokenAsync("tokenreset@test.com");

        var result = await _identity.ResetPasswordWithTokenAsync("tokenreset@test.com", token!, "NewPassword456!");

        result.Should().BeTrue();
        var loginResult = await _sut.LoginAsync("tokenreset@test.com", "NewPassword456!");
        loginResult.Should().NotBeNull();
    }

    [Fact]
    public async Task ResetPasswordWithTokenAsync_ShouldReturnFalse_WhenTokenIsInvalid()
    {
        await SeedUserAsync("badtoken@test.com");

        var result = await _identity.ResetPasswordWithTokenAsync("badtoken@test.com", "wrong-token", "NewPassword456!");

        result.Should().BeFalse();
    }

    [Fact]
    public async Task ResetPasswordWithTokenAsync_ShouldReturnFalse_WhenTokenIsExpired()
    {
        await SeedUserAsync("expired@test.com");
        await _identity.GeneratePasswordResetTokenAsync("expired@test.com");

        // Expire the token
        var user = await _context.Users.IgnoreQueryFilters().FirstAsync(u => u.Email == "expired@test.com");
        user.PasswordResetTokenExpiresUtc = DateTime.UtcNow.AddHours(-1);
        await _context.SaveChangesAsync();

        var result = await _identity.ResetPasswordWithTokenAsync("expired@test.com", user.PasswordResetToken!, "NewPassword456!");

        result.Should().BeFalse();
    }
}
