using Domain;
using MediatR;

namespace Application.Auth.Commands;

public record LoginCommand(string Email, string Password, string? DeviceId, string? UserAgent, string? IpAddress)
    : IRequest<Result<(string AccessToken, string RefreshToken, int ExpiresInSeconds)>>;
