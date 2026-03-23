using Application.Interfaces;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MimeKit;

namespace Infrastructure.Auth;

public class SmtpEmailSender : IEmailSender
{
    private readonly IConfiguration _configuration;
    private readonly ILogger<SmtpEmailSender> _logger;

    public SmtpEmailSender(IConfiguration configuration, ILogger<SmtpEmailSender> logger)
    {
        _configuration = configuration;
        _logger = logger;
    }

    public async Task SendEmailAsync(string email, string subject, string htmlMessage)
    {
        var smtpSettings = _configuration.GetSection("SmtpSettings");
        var host = smtpSettings.GetValue<string>("Host");
        var port = smtpSettings.GetValue<int>("Port");
        var userName = smtpSettings.GetValue<string>("UserName");
        var password = smtpSettings.GetValue<string>("Password");
        var fromEmail = smtpSettings.GetValue<string>("FromEmail");
        var fromName = smtpSettings.GetValue<string>("FromName");
        var enableSsl = smtpSettings.GetValue<bool>("EnableSsl", true);

        if (string.IsNullOrEmpty(host))
        {
            _logger.LogWarning("SMTP Host is not configured. Email to {Email} was not sent.", email);
            return;
        }

        var message = new MimeMessage();
        message.From.Add(new MailboxAddress(fromName, fromEmail ?? string.Empty));
        message.To.Add(new MailboxAddress("", email));
        message.Subject = subject;

        message.Body = new TextPart("html")
        {
            Text = htmlMessage
        };

        using var client = new SmtpClient();
        try
        {
            await client.ConnectAsync(host, port, enableSsl ? SecureSocketOptions.StartTls : SecureSocketOptions.None);

            if (!string.IsNullOrEmpty(userName))
            {
                await client.AuthenticateAsync(userName, password);
            }

            await client.SendAsync(message);
            await client.DisconnectAsync(true);

            _logger.LogInformation("Email to {Email} sent successfully via SMTP.", email);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to send email to {Email} via SMTP.", email);
            throw;
        }
    }
}
