using System.Security.Claims;
using Application;
using Application.Auth.Commands;
using Asp.Versioning;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.FeatureManagement;

namespace Host.Controllers.Api;

[ApiController]
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/[controller]")]
[EnableRateLimiting("AuthPolicy")]
public class AuthController(IMediator mediator, IFeatureManager featureManager) : ControllerBase
{
    [HttpPost("login")]
    [AllowAnonymous]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var result = await mediator.Send(new LoginCommand(
            request.Email, request.Password, request.DeviceId,
            Request.Headers.UserAgent.ToString(),
            Request.HttpContext.Connection.RemoteIpAddress?.ToString()));

        if (!result.IsSuccess)
            return Unauthorized(new ProblemDetails { Detail = result.Error, Status = StatusCodes.Status401Unauthorized });

        return Ok(new
        {
            accessToken = result.Value.AccessToken,
            refreshToken = result.Value.RefreshToken,
            expiresInSeconds = result.Value.ExpiresInSeconds
        });
    }

    [HttpPost("refresh")]
    [AllowAnonymous]
    public async Task<IActionResult> Refresh([FromBody] RefreshRequest request)
    {
        var result = await mediator.Send(new RefreshTokenCommand(
            request.RefreshToken, request.DeviceId,
            Request.Headers.UserAgent.ToString(),
            Request.HttpContext.Connection.RemoteIpAddress?.ToString()));

        if (!result.IsSuccess)
            return Unauthorized(new ProblemDetails { Detail = result.Error, Status = StatusCodes.Status401Unauthorized });

        return Ok(new
        {
            accessToken = result.Value.AccessToken,
            refreshToken = result.Value.RefreshToken,
            expiresInSeconds = result.Value.ExpiresInSeconds
        });
    }

    [HttpPost("logout")]
    [Authorize(Policy = "ApiUser")]
    public async Task<IActionResult> Logout([FromBody] RefreshRequest request)
    {
        await mediator.Send(new LogoutCommand(request.RefreshToken));
        return Ok();
    }

    [HttpPost("change-password")]
    [Authorize(Policy = "ApiUser")]
    public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequest request)
    {
        var userId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
        var result = await mediator.Send(new ChangePasswordCommand(userId, request.OldPassword, request.NewPassword));

        if (!result.IsSuccess)
            return BadRequest(new ProblemDetails { Detail = result.Error, Status = StatusCodes.Status400BadRequest });

        return Ok();
    }

    [HttpPost("register")]
    [AllowAnonymous]
    public async Task<IActionResult> Register([FromBody] RegisterRequest request)
    {
        if (!await featureManager.IsEnabledAsync(FeatureFlags.TenantSelfServiceRegistration))
            return StatusCode(StatusCodes.Status403Forbidden,
                new ProblemDetails { Detail = "Self-service registration is currently disabled.", Status = StatusCodes.Status403Forbidden });

        var result = await mediator.Send(new RegisterCommand(request.Email, request.Password, request.AccountName));

        if (!result.IsSuccess)
            return Conflict(new ProblemDetails { Detail = result.Error, Status = StatusCodes.Status409Conflict });

        return Ok();
    }

    [HttpPost("forgot-password")]
    [AllowAnonymous]
    public async Task<IActionResult> ForgotPassword([FromBody] ForgotPasswordRequest request)
    {
        await mediator.Send(new ForgotPasswordCommand(request.Email));
        return Ok();
    }

    [HttpPost("reset-password")]
    [AllowAnonymous]
    public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordRequest request)
    {
        var result = await mediator.Send(new ResetPasswordCommand(request.Email, request.Token, request.NewPassword));

        if (!result.IsSuccess)
            return BadRequest(new ProblemDetails { Detail = result.Error, Status = StatusCodes.Status400BadRequest });

        return Ok();
    }
}

public record LoginRequest(string Email, string Password, string? DeviceId = null);

public record RefreshRequest(string RefreshToken, string? DeviceId = null);

public record ChangePasswordRequest(string OldPassword, string NewPassword);

public record RegisterRequest(string Email, string Password, string AccountName);

public record ForgotPasswordRequest(string Email);

public record ResetPasswordRequest(string Email, string Token, string NewPassword);
