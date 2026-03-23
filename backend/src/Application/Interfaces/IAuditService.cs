namespace Application.Interfaces;

public interface IAuditService
{
    Task LogAsync(string action, string actorEmail, string? entityType = null, string? entityId = null,
        object? metadata = null);
}
