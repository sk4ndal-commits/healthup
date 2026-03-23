using Application.Auth.Commands;
using Application.Interfaces;
using Domain;
using MediatR;

namespace Application.Auth.Handlers;

public class LogoutHandler(IAuthenticationService authService) : IRequestHandler<LogoutCommand, Result>
{
    public async Task<Result> Handle(LogoutCommand request, CancellationToken cancellationToken)
    {
        var success = await authService.LogoutAsync(request.RefreshToken);
        return success ? Result.Success() : Result.Failure("Token not found");
    }
}
