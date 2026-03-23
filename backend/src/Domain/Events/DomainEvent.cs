namespace Domain.Events;

/// <summary>
/// Base record for domain events. Provides default EventId and OccurredAtUtc values.
/// </summary>
public abstract record DomainEvent : IDomainEvent
{
    public Guid EventId { get; init; } = Guid.NewGuid();
    public DateTime OccurredAtUtc { get; init; } = DateTime.UtcNow;
}
