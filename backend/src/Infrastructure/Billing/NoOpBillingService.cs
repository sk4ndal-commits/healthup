using Application.Interfaces;
using Microsoft.Extensions.Logging;

namespace Infrastructure.Billing;

/// <summary>
/// No-op billing service used until a real payment provider is integrated.
/// Replace with a Stripe/Paddle implementation and register it in ServiceCollectionExtensions.
/// </summary>
public class NoOpBillingService(ILogger<NoOpBillingService> logger) : IBillingService
{
    public Task<BillingResult> CreateSubscriptionAsync(int accountId, string planId, CancellationToken cancellationToken = default)
    {
        logger.LogInformation("[BILLING STUB] CreateSubscription for account {AccountId}, plan {PlanId}", accountId, planId);
        return Task.FromResult(BillingResult.Success());
    }

    public Task<BillingResult> CancelSubscriptionAsync(int accountId, CancellationToken cancellationToken = default)
    {
        logger.LogInformation("[BILLING STUB] CancelSubscription for account {AccountId}", accountId);
        return Task.FromResult(BillingResult.Success());
    }

    public Task<SubscriptionStatus?> GetSubscriptionStatusAsync(int accountId, CancellationToken cancellationToken = default)
    {
        logger.LogInformation("[BILLING STUB] GetSubscriptionStatus for account {AccountId}", accountId);
        return Task.FromResult<SubscriptionStatus?>(null);
    }
}
