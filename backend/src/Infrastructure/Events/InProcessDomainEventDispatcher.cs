using Application.Interfaces;
using Domain.Events;
using MediatR;
using Microsoft.Extensions.Logging;

namespace Infrastructure.Events;

/// <summary>
/// In-process domain event dispatcher. Publishes events via MediatR.
/// Replace or extend with an outbox-based implementation for reliable delivery
/// across service boundaries (see OutboxDomainEventDispatcher stub below).
/// </summary>
public class InProcessDomainEventDispatcher(IPublisher publisher, ILogger<InProcessDomainEventDispatcher> logger)
    : IDomainEventDispatcher
{
    public async Task DispatchAsync(IDomainEvent domainEvent, CancellationToken cancellationToken = default)
    {
        logger.LogInformation("Dispatching domain event {EventType} ({EventId})",
            domainEvent.GetType().Name, domainEvent.EventId);

        if (domainEvent is INotification notification)
            await publisher.Publish(notification, cancellationToken);
        else
            logger.LogWarning("Domain event {EventType} does not implement INotification — skipped in-process dispatch",
                domainEvent.GetType().Name);
    }

    public async Task DispatchAsync(IEnumerable<IDomainEvent> domainEvents, CancellationToken cancellationToken = default)
    {
        foreach (var evt in domainEvents)
            await DispatchAsync(evt, cancellationToken);
    }
}
