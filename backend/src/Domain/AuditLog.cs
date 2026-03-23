namespace Domain;

public class AuditLog
{
    public Guid Id { get; set; }
    public Guid? ActorUserId { get; set; }
    public string? ActorEmail { get; set; }

    public string Action { get; set; } = default!;
    public string? EntityType { get; set; }
    public string? EntityId { get; set; }

    public string? MetadataJson { get; set; }

    public DateTime TimestampUtc { get; set; }
}
