using Application.Interfaces;
using Microsoft.Extensions.Logging;

namespace Infrastructure.Auth;

public class MockEmailSender : IEmailSender
{
    private readonly ILogger<MockEmailSender> _logger;

    public MockEmailSender(ILogger<MockEmailSender> logger)
    {
        _logger = logger;
    }

    public Task SendEmailAsync(string email, string subject, string htmlMessage)
    {
        _logger.LogInformation("Sending email to {Email} with subject {Subject}. Message: {Message}", email, subject, htmlMessage);
        return Task.CompletedTask;
    }
}
