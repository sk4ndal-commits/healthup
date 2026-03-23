using Application.Auth.Commands;
using Application.Interfaces;
using Domain;
using MediatR;

namespace Application.Auth.Handlers;

public class RefreshTokenHandler(IAuthenticationService authService)
    : IRequestHandler<RefreshTokenCommand, Result<(string AccessToken, string RefreshToken, int ExpiresInSeconds)>>
{
    public async Task<Result<(string AccessToken, string RefreshToken, int ExpiresInSeconds)>> Handle(
        RefreshTokenCommand request, CancellationToken cancellationToken)
    {
        var result = await authService.RefreshTokenAsync(request.RefreshToken, request.DeviceId, request.UserAgent, request.IpAddress);
        return result.HasValue
            ? Result<(string, string, int)>.Success(result.Value)
            : Result<(string, string, int)>.Failure("Invalid or expired refresh token");
    }
}
