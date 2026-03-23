namespace Application.Interfaces;

/// <summary>
/// Reserved extension point for billing / subscription management.
/// Implement against Stripe, Paddle, or any other payment provider.
/// </summary>
public interface IBillingService
{
    /// <summary>Create a new subscription for a tenant after self-service registration.</summary>
    Task<BillingResult> CreateSubscriptionAsync(int accountId, string planId, CancellationToken cancellationToken = default);

    /// <summary>Cancel an active subscription (e.g. on tenant offboarding).</summary>
    Task<BillingResult> CancelSubscriptionAsync(int accountId, CancellationToken cancellationToken = default);

    /// <summary>Retrieve the current subscription status for a tenant.</summary>
    Task<SubscriptionStatus?> GetSubscriptionStatusAsync(int accountId, CancellationToken cancellationToken = default);
}

public record BillingResult(bool IsSuccess, string? Error = null)
{
    public static BillingResult Success() => new(true);
    public static BillingResult Failure(string error) => new(false, error);
}

public record SubscriptionStatus(
    int AccountId,
    string PlanId,
    string Status,       // e.g. "active", "trialing", "past_due", "canceled"
    DateTime? TrialEndsAt,
    DateTime? CurrentPeriodEnd
);
