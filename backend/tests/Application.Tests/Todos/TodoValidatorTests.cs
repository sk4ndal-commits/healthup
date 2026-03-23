using Application.Todos.Commands;
using Application.Todos.Validators;
using FluentAssertions;
using Microsoft.Extensions.Localization;
using NSubstitute;

namespace Application.Tests.Todos;

public class TodoValidatorTests
{
    private static IStringLocalizer BuildLocalizer()
    {
        var localizer = Substitute.For<IStringLocalizer>();
        localizer[Arg.Any<string>()].Returns(x => new LocalizedString(x.Arg<string>(), x.Arg<string>()));
        return localizer;
    }

    // --- CreateTodoCommandValidator ---

    [Fact]
    public void CreateTodoValidator_ShouldFail_WhenTitleIsEmpty()
    {
        var validator = new CreateTodoCommandValidator(BuildLocalizer());
        var result = validator.Validate(new CreateTodoCommand("", "user@example.com"));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "Title");
    }

    [Fact]
    public void CreateTodoValidator_ShouldFail_WhenTitleExceedsMaxLength()
    {
        var validator = new CreateTodoCommandValidator(BuildLocalizer());
        var longTitle = new string('A', 501);
        var result = validator.Validate(new CreateTodoCommand(longTitle, "user@example.com"));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "Title");
    }

    [Fact]
    public void CreateTodoValidator_ShouldFail_WhenActorEmailIsEmpty()
    {
        var validator = new CreateTodoCommandValidator(BuildLocalizer());
        var result = validator.Validate(new CreateTodoCommand("My Todo", ""));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "ActorEmail");
    }

    [Fact]
    public void CreateTodoValidator_ShouldPass_WithValidInput()
    {
        var validator = new CreateTodoCommandValidator(BuildLocalizer());
        var result = validator.Validate(new CreateTodoCommand("My Todo", "user@example.com"));
        result.IsValid.Should().BeTrue();
    }

    // --- UpdateTodoCommandValidator ---

    [Fact]
    public void UpdateTodoValidator_ShouldFail_WhenIdIsZero()
    {
        var validator = new UpdateTodoCommandValidator(BuildLocalizer());
        var result = validator.Validate(new UpdateTodoCommand(0, "My Todo", false, "user@example.com"));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "Id");
    }

    [Fact]
    public void UpdateTodoValidator_ShouldFail_WhenTitleIsEmpty()
    {
        var validator = new UpdateTodoCommandValidator(BuildLocalizer());
        var result = validator.Validate(new UpdateTodoCommand(1, "", false, "user@example.com"));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "Title");
    }

    [Fact]
    public void UpdateTodoValidator_ShouldFail_WhenTitleExceedsMaxLength()
    {
        var validator = new UpdateTodoCommandValidator(BuildLocalizer());
        var longTitle = new string('A', 501);
        var result = validator.Validate(new UpdateTodoCommand(1, longTitle, false, "user@example.com"));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "Title");
    }

    [Fact]
    public void UpdateTodoValidator_ShouldPass_WithValidInput()
    {
        var validator = new UpdateTodoCommandValidator(BuildLocalizer());
        var result = validator.Validate(new UpdateTodoCommand(1, "My Todo", false, "user@example.com"));
        result.IsValid.Should().BeTrue();
    }
}
