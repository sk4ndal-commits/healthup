using Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Infrastructure.Auth;

public class RefreshTokenCleanupService : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly IConfiguration _configuration;
    private readonly ILogger<RefreshTokenCleanupService> _logger;

    public RefreshTokenCleanupService(
        IServiceProvider serviceProvider,
        IConfiguration configuration,
        ILogger<RefreshTokenCleanupService> logger)
    {
        _serviceProvider = serviceProvider;
        _configuration = configuration;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Refresh Token Cleanup Service is starting.");

        while (!stoppingToken.IsCancellationRequested)
        {
            _logger.LogInformation("Refresh Token Cleanup Service is working.");

            await CleanupTokens(stoppingToken);

            // Run daily
            await Task.Delay(TimeSpan.FromDays(1), stoppingToken);
        }

        _logger.LogInformation("Refresh Token Cleanup Service is stopping.");
    }

    private async Task CleanupTokens(CancellationToken stoppingToken)
    {
        try
        {
            using var scope = _serviceProvider.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<AppDbContext>();

            var expiredDays = _configuration.GetValue<int>("JwtSettings:CleanupExpiredDays", 7);
            var revokedDays = _configuration.GetValue<int>("JwtSettings:CleanupRevokedDays", 7);

            var expiredThreshold = DateTime.UtcNow.AddDays(-expiredDays);
            var revokedThreshold = DateTime.UtcNow.AddDays(-revokedDays);

            var tokensToDelete = await context.RefreshTokens
                .IgnoreQueryFilters()
                .Where(t => (t.ExpiresAtUtc < expiredThreshold) ||
                            (t.RevokedAtUtc != null && t.RevokedAtUtc < revokedThreshold))
                .ToListAsync(stoppingToken);

            if (tokensToDelete.Any())
            {
                context.RefreshTokens.RemoveRange(tokensToDelete);
                await context.SaveChangesAsync(stoppingToken);
                _logger.LogInformation("Deleted {Count} old refresh tokens.", tokensToDelete.Count);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error occurred while cleaning up refresh tokens.");
        }
    }
}
