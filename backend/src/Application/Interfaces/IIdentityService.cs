using Domain;

namespace Application.Interfaces;

public interface IIdentityService
{
    Task<bool> ChangePasswordAsync(int userId, string oldPassword, string newPassword);
    Task<bool> ResetPasswordAsync(int userId, string newPassword);
    Task<bool> CreateUserAsync(User user, string password);
    Task<bool> ToggleUserActiveAsync(int userId, int currentUserId);
    Task<bool> RegisterAsync(string email, string password, string accountName);
    Task<string?> GeneratePasswordResetTokenAsync(string email);
    Task<bool> ResetPasswordWithTokenAsync(string email, string token, string newPassword);
}
