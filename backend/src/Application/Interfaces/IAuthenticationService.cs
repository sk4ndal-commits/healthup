namespace Application.Interfaces;

public interface IAuthenticationService
{
    Task<(string AccessToken, string RefreshToken, int ExpiresInSeconds)?> LoginAsync(string email, string password, string? deviceId = null, string? userAgent = null, string? ipAddress = null);
    Task<(string AccessToken, string RefreshToken, int ExpiresInSeconds)?> RefreshTokenAsync(string refreshToken, string? deviceId = null, string? userAgent = null, string? ipAddress = null);
    Task<bool> LogoutAsync(string refreshToken);
}
