using System.Text.Json;
using Application.Interfaces;
using Domain;
using Infrastructure.Persistence;

namespace Infrastructure.Persistence;

public class AuditService : IAuditService
{
    private readonly AppDbContext _context;

    public AuditService(AppDbContext context)
    {
        _context = context;
    }

    public async Task LogAsync(string action, string actorEmail, string? entityType = null, string? entityId = null, object? metadata = null)
    {
        var log = new AuditLog
        {
            Id = Guid.NewGuid(),
            Action = action,
            ActorEmail = actorEmail,
            EntityType = entityType,
            EntityId = entityId,
            TimestampUtc = DateTime.UtcNow,
            MetadataJson = metadata != null ? JsonSerializer.Serialize(metadata) : null
        };

        _context.AuditLogs.Add(log);
        await _context.SaveChangesAsync();
    }
}
