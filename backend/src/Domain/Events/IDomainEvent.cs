namespace Domain.Events;

/// <summary>
/// Marker interface for all domain events.
/// Implement this interface on any record/class that represents something that happened in the domain.
/// </summary>
public interface IDomainEvent
{
    Guid EventId { get; }
    DateTime OccurredAtUtc { get; }
}
