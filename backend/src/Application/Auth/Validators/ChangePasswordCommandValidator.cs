using Application.Auth.Commands;
using FluentValidation;
using Microsoft.Extensions.Localization;

namespace Application.Auth.Validators;

public class ChangePasswordCommandValidator : AbstractValidator<ChangePasswordCommand>
{
    public ChangePasswordCommandValidator(IStringLocalizer localizer)
    {
        RuleFor(x => x.OldPassword)
            .NotEmpty().WithMessage(localizer["FieldRequired"]);

        RuleFor(x => x.NewPassword)
            .NotEmpty().WithMessage(localizer["FieldRequired"])
            .MinimumLength(8).WithMessage(localizer["MinLength"]);
    }
}
