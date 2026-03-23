using Application.Auth.Commands;
using FluentValidation;
using Microsoft.Extensions.Localization;

namespace Application.Auth.Validators;

public class LoginCommandValidator : AbstractValidator<LoginCommand>
{
    public LoginCommandValidator(IStringLocalizer localizer)
    {
        RuleFor(x => x.Email)
            .NotEmpty().WithMessage(localizer["FieldRequired"])
            .EmailAddress().WithMessage(localizer["InvalidEmail"]);

        RuleFor(x => x.Password)
            .NotEmpty().WithMessage(localizer["FieldRequired"])
            .MinimumLength(6).WithMessage(localizer["MinLength"]);
    }
}
