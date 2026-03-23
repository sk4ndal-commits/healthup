using Domain.Events;

namespace Application.Interfaces;

/// <summary>
/// Dispatches domain events either in-process or via an outbox table.
/// Swap the implementation to enable reliable async delivery (outbox pattern).
/// </summary>
public interface IDomainEventDispatcher
{
    /// <summary>Dispatch a single domain event.</summary>
    Task DispatchAsync(IDomainEvent domainEvent, CancellationToken cancellationToken = default);

    /// <summary>Dispatch multiple domain events in order.</summary>
    Task DispatchAsync(IEnumerable<IDomainEvent> domainEvents, CancellationToken cancellationToken = default);
}
