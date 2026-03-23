namespace Domain.Events;

/// <summary>
/// Raised when a new tenant (Account) self-registers.
/// Consumers can send a welcome email, provision default data, notify billing, etc.
/// </summary>
public record TenantRegisteredEvent(int AccountId, string AccountName, string OwnerEmail) : DomainEvent;
