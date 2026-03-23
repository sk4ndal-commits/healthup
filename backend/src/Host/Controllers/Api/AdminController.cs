using System.Security.Claims;
using Application.Interfaces;
using Asp.Versioning;
using Domain;
using Infrastructure.Persistence;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Localization;

namespace Host.Controllers.Api;

[ApiController]
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/[controller]")]
[Authorize(Policy = "AdminOnly")]
public class AdminController(
    AppDbContext dbContext,
    IIdentityService identityService,
    IStringLocalizer<AdminController> localizer)
    : ControllerBase
{
    [HttpGet("users")]
    public async Task<IActionResult> GetUsers()
    {
        var users = await dbContext.Users
            .IgnoreQueryFilters()
            .Select(u => new UserDto(u.Id, u.Email, u.Role, u.IsActive, u.CreatedAtUtc, u.AccountId))
            .ToListAsync();

        return Ok(users);
    }

    [HttpGet("users/{id:int}")]
    public async Task<IActionResult> GetUser(int id)
    {
        var user = await dbContext.Users
            .IgnoreQueryFilters()
            .Where(u => u.Id == id)
            .Select(u => new UserDto(u.Id, u.Email, u.Role, u.IsActive, u.CreatedAtUtc, u.AccountId))
            .FirstOrDefaultAsync();

        if (user is null) return NotFound();
        return Ok(user);
    }

    [HttpPost("users")]
    public async Task<IActionResult> CreateUser([FromBody] CreateUserRequest request)
    {
        var user = new User
        {
            Email = request.Email,
            Role = request.Role,
            IsActive = true,
            AccountId = request.AccountId
        };

        var result = await identityService.CreateUserAsync(user, request.Password);
        if (!result)
        {
            return Conflict(new ProblemDetails
            {
                Detail = localizer["Email already in use"],
                Status = StatusCodes.Status409Conflict
            });
        }

        return CreatedAtAction(nameof(GetUser), new { id = user.Id },
            new UserDto(user.Id, user.Email, user.Role, user.IsActive, user.CreatedAtUtc, user.AccountId));
    }

    [HttpPost("users/{id:int}/reset-password")]
    public async Task<IActionResult> ResetPassword(int id, [FromBody] AdminResetPasswordRequest request)
    {
        var result = await identityService.ResetPasswordAsync(id, request.NewPassword);
        if (!result)
        {
            return NotFound(new ProblemDetails
            {
                Detail = localizer["User not found"],
                Status = StatusCodes.Status404NotFound
            });
        }

        return Ok();
    }

    [HttpPost("users/{id:int}/toggle-active")]
    public async Task<IActionResult> ToggleActive(int id)
    {
        var currentUserId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
        var result = await identityService.ToggleUserActiveAsync(id, currentUserId);
        if (!result)
        {
            return BadRequest(new ProblemDetails
            {
                Detail = localizer["Cannot toggle the active state of this user"],
                Status = StatusCodes.Status400BadRequest
            });
        }

        return Ok();
    }
}

public record UserDto(int Id, string Email, string Role, bool IsActive, DateTime CreatedAtUtc, int AccountId);

public record CreateUserRequest(string Email, string Password, string Role, int AccountId);

public record AdminResetPasswordRequest(string NewPassword);
