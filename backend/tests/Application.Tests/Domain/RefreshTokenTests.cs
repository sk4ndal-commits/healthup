using Domain;
using FluentAssertions;

namespace Application.Tests.Domain;

public class RefreshTokenTests
{
    [Fact]
    public void IsExpired_ShouldBeTrue_WhenExpiresAtUtcIsInThePast()
    {
        var token = new RefreshToken { ExpiresAtUtc = DateTime.UtcNow.AddHours(-1) };
        token.IsExpired.Should().BeTrue();
    }

    [Fact]
    public void IsExpired_ShouldBeFalse_WhenExpiresAtUtcIsInTheFuture()
    {
        var token = new RefreshToken { ExpiresAtUtc = DateTime.UtcNow.AddHours(1) };
        token.IsExpired.Should().BeFalse();
    }

    [Fact]
    public void IsRevoked_ShouldBeTrue_WhenRevokedAtUtcIsSet()
    {
        var token = new RefreshToken { ExpiresAtUtc = DateTime.UtcNow.AddHours(1), RevokedAtUtc = DateTime.UtcNow };
        token.IsRevoked.Should().BeTrue();
    }

    [Fact]
    public void IsRevoked_ShouldBeFalse_WhenRevokedAtUtcIsNull()
    {
        var token = new RefreshToken { ExpiresAtUtc = DateTime.UtcNow.AddHours(1) };
        token.IsRevoked.Should().BeFalse();
    }

    [Fact]
    public void IsActive_ShouldBeTrue_WhenNotExpiredAndNotRevoked()
    {
        var token = new RefreshToken { ExpiresAtUtc = DateTime.UtcNow.AddHours(1) };
        token.IsActive.Should().BeTrue();
    }

    [Fact]
    public void IsActive_ShouldBeFalse_WhenExpired()
    {
        var token = new RefreshToken { ExpiresAtUtc = DateTime.UtcNow.AddHours(-1) };
        token.IsActive.Should().BeFalse();
    }

    [Fact]
    public void IsActive_ShouldBeFalse_WhenRevoked()
    {
        var token = new RefreshToken { ExpiresAtUtc = DateTime.UtcNow.AddHours(1), RevokedAtUtc = DateTime.UtcNow };
        token.IsActive.Should().BeFalse();
    }
}
