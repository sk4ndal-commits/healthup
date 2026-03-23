namespace Domain;

public class RefreshToken
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public int AccountId { get; set; }
    public string Token { get; set; } = string.Empty;
    public DateTime ExpiresAtUtc { get; set; }
    public DateTime CreatedAtUtc { get; set; }
    public DateTime? RevokedAtUtc { get; set; }
    public string? ReplacedByToken { get; set; }

    public string? DeviceId { get; set; }
    public string? UserAgent { get; set; }
    public string? IpAddress { get; set; }

    public bool IsExpired => DateTime.UtcNow >= ExpiresAtUtc;
    public bool IsRevoked => RevokedAtUtc != null;
    public bool IsActive => !IsRevoked && !IsExpired;

    public User User { get; set; } = null!;
}
