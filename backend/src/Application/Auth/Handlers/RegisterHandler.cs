using Application.Auth.Commands;
using Application.Interfaces;
using Domain;
using Domain.Events;
using MediatR;
using Microsoft.Extensions.Localization;

namespace Application.Auth.Handlers;

public class RegisterHandler(IIdentityService identityService, IDomainEventDispatcher eventDispatcher, IStringLocalizer localizer)
    : IRequestHandler<RegisterCommand, Result>
{
    public async Task<Result> Handle(RegisterCommand request, CancellationToken cancellationToken)
    {
        var success = await identityService.RegisterAsync(request.Email, request.Password, request.AccountName);
        if (!success)
            return Result.Failure(localizer["EmailAlreadyInUse"]);

        await eventDispatcher.DispatchAsync(
            new TenantRegisteredEvent(0, request.AccountName, request.Email),
            cancellationToken);

        return Result.Success();
    }
}
