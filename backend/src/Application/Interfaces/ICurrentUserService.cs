namespace Application.Interfaces;

public interface ICurrentUserService
{
    int? UserId { get; }
    int? AccountId { get; }
    string? UserEmail { get; }
}
