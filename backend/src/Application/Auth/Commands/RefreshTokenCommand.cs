using Domain;
using MediatR;

namespace Application.Auth.Commands;

public record RefreshTokenCommand(string RefreshToken, string? DeviceId, string? UserAgent, string? IpAddress)
    : IRequest<Result<(string AccessToken, string RefreshToken, int ExpiresInSeconds)>>;
