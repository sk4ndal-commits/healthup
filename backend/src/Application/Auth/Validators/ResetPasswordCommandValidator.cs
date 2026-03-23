using Application.Auth.Commands;
using FluentValidation;
using Microsoft.Extensions.Localization;

namespace Application.Auth.Validators;

public class ResetPasswordCommandValidator : AbstractValidator<ResetPasswordCommand>
{
    public ResetPasswordCommandValidator(IStringLocalizer localizer)
    {
        RuleFor(x => x.Email)
            .NotEmpty().WithMessage(localizer["FieldRequired"])
            .EmailAddress().WithMessage(localizer["InvalidEmail"]);

        RuleFor(x => x.Token)
            .NotEmpty().WithMessage(localizer["FieldRequired"]);

        RuleFor(x => x.NewPassword)
            .NotEmpty().WithMessage(localizer["FieldRequired"])
            .MinimumLength(8).WithMessage(localizer["MinLength"]);
    }
}
