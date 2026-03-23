using Application.Auth.Commands;
using Application.Interfaces;
using Domain;
using MediatR;
using Microsoft.Extensions.Localization;

namespace Application.Auth.Handlers;

public class ResetPasswordHandler(IIdentityService identityService, IStringLocalizer localizer) : IRequestHandler<ResetPasswordCommand, Result>
{
    public async Task<Result> Handle(ResetPasswordCommand request, CancellationToken cancellationToken)
    {
        var success = await identityService.ResetPasswordWithTokenAsync(request.Email, request.Token, request.NewPassword);
        return success ? Result.Success() : Result.Failure(localizer["InvalidOrExpiredToken"]);
    }
}
