using Application.Todos.Commands;
using FluentValidation;
using Microsoft.Extensions.Localization;

namespace Application.Todos.Validators;

public class CreateTodoCommandValidator : AbstractValidator<CreateTodoCommand>
{
    public CreateTodoCommandValidator(IStringLocalizer localizer)
    {
        RuleFor(x => x.Title)
            .NotEmpty().WithMessage(localizer["FieldRequired"])
            .MaximumLength(500).WithMessage(localizer["MaxLength"]);

        RuleFor(x => x.ActorEmail)
            .NotEmpty().WithMessage(localizer["FieldRequired"]);
    }
}
