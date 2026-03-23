using Application.Auth.Commands;
using Application.Interfaces;
using Domain;
using MediatR;

namespace Application.Auth.Handlers;

public class ForgotPasswordHandler(
    IIdentityService identityService,
    IEmailSender emailSender,
    IAppSettings appSettings) : IRequestHandler<ForgotPasswordCommand, Result>
{
    public async Task<Result> Handle(ForgotPasswordCommand request, CancellationToken cancellationToken)
    {
        var token = await identityService.GeneratePasswordResetTokenAsync(request.Email);

        // Always return success to avoid email enumeration
        if (token == null) return Result.Success();

        var resetLink = $"{appSettings.FrontendUrl}/reset-password?email={Uri.EscapeDataString(request.Email)}&token={Uri.EscapeDataString(token)}";

        var subject = "Reset your password";
        var body = $"""
            <p>You requested a password reset.</p>
            <p><a href="{resetLink}">Click here to reset your password</a></p>
            <p>This link expires in 2 hours.</p>
            <p>If you did not request this, you can safely ignore this email.</p>
            """;

        await emailSender.SendEmailAsync(request.Email, subject, body);

        return Result.Success();
    }
}
