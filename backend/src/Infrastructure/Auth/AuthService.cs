using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Application.Interfaces;
using Domain;
using Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace Infrastructure.Auth;

public class AuthenticationService : IAuthenticationService
{
    private readonly AppDbContext _context;
    private readonly IConfiguration _configuration;
    private readonly IAuditService _auditService;
    private readonly Microsoft.AspNetCore.Identity.IPasswordHasher<User> _passwordHasher;

    public AuthenticationService(
        AppDbContext context,
        IConfiguration configuration,
        IAuditService auditService,
        Microsoft.AspNetCore.Identity.IPasswordHasher<User> passwordHasher)
    {
        _context = context;
        _configuration = configuration;
        _auditService = auditService;
        _passwordHasher = passwordHasher;
    }

    public async Task<(string AccessToken, string RefreshToken, int ExpiresInSeconds)?> LoginAsync(string email, string password, string? deviceId = null, string? userAgent = null, string? ipAddress = null)
    {
        var user = await _context.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Email == email && u.IsActive);
        if (user == null)
        {
            await _auditService.LogAsync("LoginFailed", email, metadata: new { Reason = "UserNotFoundOrInactive", IpAddress = ipAddress });
            return null;
        }

        var result = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, password);
        if (result == Microsoft.AspNetCore.Identity.PasswordVerificationResult.Failed)
        {
            await _auditService.LogAsync("LoginFailed", email, "User", user.Id.ToString(), new { Reason = "InvalidPassword", IpAddress = ipAddress });
            return null;
        }

        await _auditService.LogAsync("LoginSuccess", email, "User", user.Id.ToString(), new { IpAddress = ipAddress });
        return await GenerateAuthResponse(user, deviceId: deviceId, userAgent: userAgent, ipAddress: ipAddress);
    }

    public async Task<(string AccessToken, string RefreshToken, int ExpiresInSeconds)?> RefreshTokenAsync(string refreshToken, string? deviceId = null, string? userAgent = null, string? ipAddress = null)
    {
        var tokenRecord = await _context.RefreshTokens
            .IgnoreQueryFilters()
            .Include(t => t.User)
            .FirstOrDefaultAsync(t => t.Token == refreshToken);

        if (tokenRecord == null || !tokenRecord.IsActive) return null;

        // Verify DeviceId if strict mode is enabled or if record has DeviceId
        var strictDeviceId = _configuration.GetValue<bool>("JwtSettings:StrictDeviceIdCheck", false);
        if ((strictDeviceId || !string.IsNullOrEmpty(tokenRecord.DeviceId)) && tokenRecord.DeviceId != deviceId)
        {
            return null;
        }

        // Rotate refresh token
        var newRefreshToken = GenerateSecureToken();
        tokenRecord.RevokedAtUtc = DateTime.UtcNow;
        tokenRecord.ReplacedByToken = newRefreshToken;

        var user = tokenRecord.User;
        var response = await GenerateAuthResponse(user, newRefreshToken, deviceId, userAgent, ipAddress);

        return response;
    }

    public async Task<bool> LogoutAsync(string refreshToken)
    {
        var tokenRecord = await _context.RefreshTokens
            .IgnoreQueryFilters()
            .Include(t => t.User)
            .FirstOrDefaultAsync(t => t.Token == refreshToken);
        if (tokenRecord == null) return false;

        tokenRecord.RevokedAtUtc = DateTime.UtcNow;

        await _auditService.LogAsync("Logout", tokenRecord.User.Email, "User", tokenRecord.UserId.ToString());

        await _context.SaveChangesAsync();
        return true;
    }

    private async Task<(string AccessToken, string RefreshToken, int ExpiresInSeconds)> GenerateAuthResponse(User user, string? existingRefreshToken = null, string? deviceId = null, string? userAgent = null, string? ipAddress = null)
    {
        var jwtSettings = _configuration.GetSection("JwtSettings");
        var secret = jwtSettings.GetValue<string>("Secret")!;
        var issuer = jwtSettings.GetValue<string>("Issuer");
        var audience = jwtSettings.GetValue<string>("Audience");
        var expirationMinutes = jwtSettings.GetValue<int>("ExpirationMinutes", 15);
        var refreshExpirationDays = jwtSettings.GetValue<int>("RefreshExpirationDays", 30);

        var key = Encoding.UTF8.GetBytes(secret);
        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
                new Claim(JwtRegisteredClaimNames.Email, user.Email),
                new Claim(ClaimTypes.Role, user.Role),
                new Claim("AccountId", user.AccountId.ToString())
            }),
            Expires = DateTime.UtcNow.AddMinutes(expirationMinutes),
            Issuer = issuer,
            Audience = audience,
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };

        var tokenHandler = new JwtSecurityTokenHandler();
        var token = tokenHandler.CreateToken(tokenDescriptor);
        var accessToken = tokenHandler.WriteToken(token);

        var refreshToken = existingRefreshToken ?? GenerateSecureToken();

        _context.RefreshTokens.Add(new RefreshToken
        {
            UserId = user.Id,
            AccountId = user.AccountId,
            Token = refreshToken,
            DeviceId = deviceId,
            UserAgent = userAgent,
            IpAddress = ipAddress,
            CreatedAtUtc = DateTime.UtcNow,
            ExpiresAtUtc = DateTime.UtcNow.AddDays(refreshExpirationDays)
        });

        await _context.SaveChangesAsync();

        return (accessToken, refreshToken, expirationMinutes * 60);
    }

    private string GenerateSecureToken()
    {
        var randomNumber = new byte[64];
        using var rng = RandomNumberGenerator.Create();
        rng.GetBytes(randomNumber);
        return Convert.ToBase64String(randomNumber);
    }
}

public class IdentityService : IIdentityService
{
    private readonly AppDbContext _context;
    private readonly IAuditService _auditService;
    private readonly Microsoft.AspNetCore.Identity.IPasswordHasher<User> _passwordHasher;

    public IdentityService(
        AppDbContext context,
        IAuditService auditService,
        Microsoft.AspNetCore.Identity.IPasswordHasher<User> passwordHasher)
    {
        _context = context;
        _auditService = auditService;
        _passwordHasher = passwordHasher;
    }

    public async Task<bool> ChangePasswordAsync(int userId, string oldPassword, string newPassword)
    {
        var user = await _context.Users.FindAsync(userId);
        if (user == null) return false;

        var result = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, oldPassword);
        if (result == Microsoft.AspNetCore.Identity.PasswordVerificationResult.Failed) return false;

        user.PasswordHash = _passwordHasher.HashPassword(user, newPassword);

        await _auditService.LogAsync("ChangePassword", user.Email, "User", user.Id.ToString());

        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<bool> ResetPasswordAsync(int userId, string newPassword)
    {
        var user = await _context.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Id == userId);
        if (user == null) return false;

        user.PasswordHash = _passwordHasher.HashPassword(user, newPassword);

        await _auditService.LogAsync("ResetPassword", "Admin", "User", user.Id.ToString());

        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<bool> CreateUserAsync(User user, string password)
    {
        if (await _context.Users.IgnoreQueryFilters().AnyAsync(u => u.Email == user.Email)) return false;

        user.PasswordHash = _passwordHasher.HashPassword(user, password);
        user.CreatedAtUtc = DateTime.UtcNow;

        _context.Users.Add(user);

        await _auditService.LogAsync("CreateUser", "Admin", "User", user.Email, new { Role = user.Role });

        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<bool> ToggleUserActiveAsync(int userId, int currentUserId)
    {
        if (userId == currentUserId) return false;

        var user = await _context.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Id == userId);
        if (user == null) return false;

        user.IsActive = !user.IsActive;

        await _auditService.LogAsync(user.IsActive ? "ActivateUser" : "DeactivateUser", "Admin", "User", user.Id.ToString(), new { AdminId = currentUserId });

        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<bool> RegisterAsync(string email, string password, string accountName)
    {
        if (await _context.Users.IgnoreQueryFilters().AnyAsync(u => u.Email == email)) return false;

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            var account = new Account
            {
                Name = accountName,
                CreatedAtUtc = DateTime.UtcNow
            };
            _context.Accounts.Add(account);
            await _context.SaveChangesAsync();

            var user = new User
            {
                Email = email,
                Role = "User",
                IsActive = true,
                CreatedAtUtc = DateTime.UtcNow,
                AccountId = account.Id
            };
            user.PasswordHash = _passwordHasher.HashPassword(user, password);
            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            await _auditService.LogAsync("Register", email, "User", user.Id.ToString(), new { AccountId = account.Id, AccountName = accountName });

            await transaction.CommitAsync();
            return true;
        }
        catch
        {
            await transaction.RollbackAsync();
            return false;
        }
    }

    public async Task<string?> GeneratePasswordResetTokenAsync(string email)
    {
        var user = await _context.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Email == email);
        if (user == null) return null;

        var token = Guid.NewGuid().ToString("N");
        user.PasswordResetToken = token;
        user.PasswordResetTokenExpiresUtc = DateTime.UtcNow.AddHours(2);

        await _context.SaveChangesAsync();
        await _auditService.LogAsync("ForgotPasswordRequested", email, "User", user.Id.ToString());

        return token;
    }

    public async Task<bool> ResetPasswordWithTokenAsync(string email, string token, string newPassword)
    {
        var user = await _context.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Email == email);
        if (user == null || user.PasswordResetToken != token || user.PasswordResetTokenExpiresUtc < DateTime.UtcNow)
        {
            return false;
        }

        user.PasswordHash = _passwordHasher.HashPassword(user, newPassword);
        user.PasswordResetToken = null;
        user.PasswordResetTokenExpiresUtc = null;

        await _context.SaveChangesAsync();
        await _auditService.LogAsync("PasswordResetWithToken", email, "User", user.Id.ToString());

        return true;
    }
}

