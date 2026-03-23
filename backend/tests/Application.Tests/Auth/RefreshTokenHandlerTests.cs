using Application.Auth.Commands;
using Application.Auth.Handlers;
using Application.Interfaces;
using FluentAssertions;
using NSubstitute;

namespace Application.Tests.Auth;

public class RefreshTokenHandlerTests
{
    private readonly IAuthenticationService _authService = Substitute.For<IAuthenticationService>();
    private readonly RefreshTokenHandler _sut;

    public RefreshTokenHandlerTests()
    {
        _sut = new RefreshTokenHandler(_authService);
    }

    [Fact]
    public async Task Handle_ShouldReturnNewTokenPair_WhenRefreshTokenIsValid()
    {
        var command = new RefreshTokenCommand("valid-token", null, null, null);
        _authService.RefreshTokenAsync(command.RefreshToken, null, null, null)
            .Returns(("new-access", "new-refresh", 3600));

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        result.Value.AccessToken.Should().Be("new-access");
        result.Value.RefreshToken.Should().Be("new-refresh");
        result.Value.ExpiresInSeconds.Should().Be(3600);
    }

    [Fact]
    public async Task Handle_ShouldReturnFailure_WhenRefreshTokenIsInvalidOrExpired()
    {
        var command = new RefreshTokenCommand("expired-token", null, null, null);
        _authService.RefreshTokenAsync(command.RefreshToken, null, null, null)
            .Returns((ValueTuple<string, string, int>?)null);

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeFalse();
        result.Error.Should().Be("Invalid or expired refresh token");
    }
}
