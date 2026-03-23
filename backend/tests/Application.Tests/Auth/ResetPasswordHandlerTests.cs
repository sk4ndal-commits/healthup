using Application.Auth.Commands;
using Application.Auth.Handlers;
using Application.Interfaces;
using FluentAssertions;
using Microsoft.Extensions.Localization;
using NSubstitute;

namespace Application.Tests.Auth;

public class ResetPasswordHandlerTests
{
    private readonly IIdentityService _identityService = Substitute.For<IIdentityService>();
    private readonly IStringLocalizer _localizer = Substitute.For<IStringLocalizer>();
    private readonly ResetPasswordHandler _sut;

    public ResetPasswordHandlerTests()
    {
        _localizer["InvalidOrExpiredToken"].Returns(new LocalizedString("InvalidOrExpiredToken", "Invalid or expired token."));
        _sut = new ResetPasswordHandler(_identityService, _localizer);
    }

    [Fact]
    public async Task Handle_ShouldReturnSuccess_WhenTokenIsValid()
    {
        var command = new ResetPasswordCommand("user@example.com", "valid-token", "NewPassword1!");
        _identityService.ResetPasswordWithTokenAsync(command.Email, command.Token, command.NewPassword).Returns(true);

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
    }

    [Fact]
    public async Task Handle_ShouldReturnFailure_WhenTokenIsInvalidOrExpired()
    {
        var command = new ResetPasswordCommand("user@example.com", "bad-token", "NewPassword1!");
        _identityService.ResetPasswordWithTokenAsync(command.Email, command.Token, command.NewPassword).Returns(false);

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeFalse();
        result.Error.Should().Be("Invalid or expired token.");
    }
}
