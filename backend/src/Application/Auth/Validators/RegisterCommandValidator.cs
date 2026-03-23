using Application.Auth.Commands;
using FluentValidation;
using Microsoft.Extensions.Localization;

namespace Application.Auth.Validators;

public class RegisterCommandValidator : AbstractValidator<RegisterCommand>
{
    public RegisterCommandValidator(IStringLocalizer localizer)
    {
        RuleFor(x => x.Email)
            .NotEmpty().WithMessage(localizer["FieldRequired"])
            .EmailAddress().WithMessage(localizer["InvalidEmail"]);

        RuleFor(x => x.Password)
            .NotEmpty().WithMessage(localizer["FieldRequired"])
            .MinimumLength(8).WithMessage(localizer["MinLength"]);

        RuleFor(x => x.AccountName)
            .NotEmpty().WithMessage(localizer["FieldRequired"])
            .MaximumLength(100).WithMessage(localizer["MaxLength"]);
    }
}
