namespace Application;

/// <summary>
/// Central registry of all feature flag names used across the application.
/// Configure flags in appsettings.json under "FeatureManagement".
/// </summary>
public static class FeatureFlags
{
    /// <summary>
    /// Enables the self-service tenant registration endpoint.
    /// When disabled, only admins can create new tenants.
    /// </summary>
    public const string TenantSelfServiceRegistration = "TenantSelfServiceRegistration";

    /// <summary>
    /// Enables the billing/subscription management features.
    /// Gate this flag until a payment provider (e.g. Stripe) is integrated.
    /// </summary>
    public const string BillingEnabled = "BillingEnabled";

    /// <summary>
    /// Enables the outbox-based domain event dispatching.
    /// When disabled, events are dispatched in-process (fire-and-forget).
    /// </summary>
    public const string OutboxDispatch = "OutboxDispatch";
}
