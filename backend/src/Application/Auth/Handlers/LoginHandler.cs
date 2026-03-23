using Application.Auth.Commands;
using Application.Interfaces;
using Domain;
using MediatR;
using Microsoft.Extensions.Localization;

namespace Application.Auth.Handlers;

public class LoginHandler(IAuthenticationService authService, IStringLocalizer localizer)
    : IRequestHandler<LoginCommand, Result<(string AccessToken, string RefreshToken, int ExpiresInSeconds)>>
{
    public async Task<Result<(string AccessToken, string RefreshToken, int ExpiresInSeconds)>> Handle(
        LoginCommand request, CancellationToken cancellationToken)
    {
        var result = await authService.LoginAsync(request.Email, request.Password, request.DeviceId, request.UserAgent, request.IpAddress);
        return result.HasValue
            ? Result<(string, string, int)>.Success(result.Value)
            : Result<(string, string, int)>.Failure(localizer["InvalidCredentials"]);
    }
}
