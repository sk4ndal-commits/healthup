using Application.Auth.Commands;
using Application.Auth.Handlers;
using Application.Interfaces;
using Domain;
using FluentAssertions;
using Microsoft.Extensions.Localization;
using NSubstitute;

namespace Application.Tests.Auth;

public class LoginHandlerTests
{
    private readonly IAuthenticationService _authService = Substitute.For<IAuthenticationService>();
    private readonly IStringLocalizer _localizer = Substitute.For<IStringLocalizer>();
    private readonly LoginHandler _sut;

    public LoginHandlerTests()
    {
        _localizer["InvalidCredentials"].Returns(new LocalizedString("InvalidCredentials", "Invalid email or password."));
        _sut = new LoginHandler(_authService, _localizer);
    }

    [Fact]
    public async Task Handle_ShouldReturnSuccess_WhenCredentialsAreValid()
    {
        var command = new LoginCommand("user@example.com", "Password1!", null, null, null);
        _authService.LoginAsync(command.Email, command.Password, null, null, null)
            .Returns(("access-token", "refresh-token", 3600));

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        result.Value.AccessToken.Should().Be("access-token");
        result.Value.RefreshToken.Should().Be("refresh-token");
        result.Value.ExpiresInSeconds.Should().Be(3600);
    }

    [Fact]
    public async Task Handle_ShouldReturnFailure_WhenCredentialsAreInvalid()
    {
        var command = new LoginCommand("user@example.com", "wrong", null, null, null);
        _authService.LoginAsync(command.Email, command.Password, null, null, null)
            .Returns((ValueTuple<string, string, int>?)null);

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeFalse();
        result.Error.Should().Be("Invalid email or password.");
    }
}
