using Application.Auth.Commands;
using Application.Auth.Handlers;
using Application.Interfaces;
using FluentAssertions;
using NSubstitute;

namespace Application.Tests.Auth;

public class LogoutHandlerTests
{
    private readonly IAuthenticationService _authService = Substitute.For<IAuthenticationService>();
    private readonly LogoutHandler _sut;

    public LogoutHandlerTests()
    {
        _sut = new LogoutHandler(_authService);
    }

    [Fact]
    public async Task Handle_ShouldReturnSuccess_WhenTokenIsRevoked()
    {
        var command = new LogoutCommand("valid-refresh-token");
        _authService.LogoutAsync(command.RefreshToken).Returns(true);

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        await _authService.Received(1).LogoutAsync(command.RefreshToken);
    }

    [Fact]
    public async Task Handle_ShouldReturnFailure_WhenTokenNotFound()
    {
        var command = new LogoutCommand("unknown-token");
        _authService.LogoutAsync(command.RefreshToken).Returns(false);

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeFalse();
        result.Error.Should().Be("Token not found");
    }
}
