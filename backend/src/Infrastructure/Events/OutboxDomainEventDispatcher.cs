using System.Text.Json;
using Application.Interfaces;
using Domain.Events;
using Microsoft.Extensions.Logging;

namespace Infrastructure.Events;

/// <summary>
/// Outbox-pattern stub for reliable domain event delivery.
/// 
/// HOW TO ACTIVATE:
///   1. Add an OutboxMessage entity + EF Core migration (Id, EventType, Payload, CreatedAt, ProcessedAt).
///   2. In DispatchAsync, serialize the event and INSERT into the outbox table (same DB transaction as the aggregate).
///   3. Add a background worker (Hangfire job or IHostedService) that polls unprocessed rows,
///      deserializes them, and publishes via IPublisher or an external message broker (RabbitMQ, Azure Service Bus, etc.).
///   4. Register this class instead of InProcessDomainEventDispatcher in ServiceCollectionExtensions.
/// 
/// This stub logs a warning so you notice when it is wired up without the full implementation.
/// </summary>
public class OutboxDomainEventDispatcher(ILogger<OutboxDomainEventDispatcher> logger) : IDomainEventDispatcher
{
    public Task DispatchAsync(IDomainEvent domainEvent, CancellationToken cancellationToken = default)
    {
        var payload = JsonSerializer.Serialize(domainEvent, domainEvent.GetType());
        logger.LogWarning(
            "[OUTBOX STUB] Event {EventType} ({EventId}) would be persisted to outbox. Payload: {Payload}",
            domainEvent.GetType().Name, domainEvent.EventId, payload);

        // TODO: persist to OutboxMessages table within the current DbContext transaction
        return Task.CompletedTask;
    }

    public async Task DispatchAsync(IEnumerable<IDomainEvent> domainEvents, CancellationToken cancellationToken = default)
    {
        foreach (var evt in domainEvents)
            await DispatchAsync(evt, cancellationToken);
    }
}
