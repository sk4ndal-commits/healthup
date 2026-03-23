using Application.Auth.Commands;
using Application.Auth.Handlers;
using Application.Interfaces;
using FluentAssertions;
using NSubstitute;

namespace Application.Tests.Auth;

public class ForgotPasswordHandlerTests
{
    private readonly IIdentityService _identityService = Substitute.For<IIdentityService>();
    private readonly IEmailSender _emailSender = Substitute.For<IEmailSender>();
    private readonly IAppSettings _appSettings = Substitute.For<IAppSettings>();
    private readonly ForgotPasswordHandler _sut;

    public ForgotPasswordHandlerTests()
    {
        _appSettings.FrontendUrl.Returns("http://localhost:5173");
        _sut = new ForgotPasswordHandler(_identityService, _emailSender, _appSettings);
    }

    [Fact]
    public async Task Handle_ShouldSendEmail_WhenEmailIsKnown()
    {
        var command = new ForgotPasswordCommand("user@example.com");
        _identityService.GeneratePasswordResetTokenAsync(command.Email).Returns("reset-token-123");

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        await _emailSender.Received(1).SendEmailAsync(
            command.Email,
            Arg.Any<string>(),
            Arg.Is<string>(body => body.Contains("reset-token-123") && body.Contains("user%40example.com")));
    }

    [Fact]
    public async Task Handle_ShouldReturnSuccess_WithoutSendingEmail_WhenEmailIsUnknown()
    {
        var command = new ForgotPasswordCommand("unknown@example.com");
        _identityService.GeneratePasswordResetTokenAsync(command.Email).Returns((string?)null);

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        await _emailSender.DidNotReceive().SendEmailAsync(Arg.Any<string>(), Arg.Any<string>(), Arg.Any<string>());
    }
}
