using Application.Auth.Commands;
using Application.Auth.Handlers;
using Application.Interfaces;
using FluentAssertions;
using Microsoft.Extensions.Localization;
using NSubstitute;

namespace Application.Tests.Auth;

public class ChangePasswordHandlerTests
{
    private readonly IIdentityService _identityService = Substitute.For<IIdentityService>();
    private readonly IStringLocalizer _localizer = Substitute.For<IStringLocalizer>();
    private readonly ChangePasswordHandler _sut;

    public ChangePasswordHandlerTests()
    {
        _localizer["PasswordChangeFailed"].Returns(new LocalizedString("PasswordChangeFailed", "Password change failed."));
        _sut = new ChangePasswordHandler(_identityService, _localizer);
    }

    [Fact]
    public async Task Handle_ShouldReturnSuccess_WhenOldPasswordIsCorrect()
    {
        var command = new ChangePasswordCommand(1, "OldPass1!", "NewPass1!");
        _identityService.ChangePasswordAsync(command.UserId, command.OldPassword, command.NewPassword).Returns(true);

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
    }

    [Fact]
    public async Task Handle_ShouldReturnFailure_WhenOldPasswordIsWrong()
    {
        var command = new ChangePasswordCommand(1, "WrongPass!", "NewPass1!");
        _identityService.ChangePasswordAsync(command.UserId, command.OldPassword, command.NewPassword).Returns(false);

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeFalse();
        result.Error.Should().Be("Password change failed.");
    }
}
