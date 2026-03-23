using Application.Auth.Commands;
using Application.Interfaces;
using Domain;
using MediatR;
using Microsoft.Extensions.Localization;

namespace Application.Auth.Handlers;

public class ChangePasswordHandler(IIdentityService identityService, IStringLocalizer localizer) : IRequestHandler<ChangePasswordCommand, Result>
{
    public async Task<Result> Handle(ChangePasswordCommand request, CancellationToken cancellationToken)
    {
        var success = await identityService.ChangePasswordAsync(request.UserId, request.OldPassword, request.NewPassword);
        return success ? Result.Success() : Result.Failure(localizer["PasswordChangeFailed"]);
    }
}
