using Application.Auth.Commands;
using Application.Auth.Validators;
using FluentAssertions;
using Microsoft.Extensions.Localization;
using NSubstitute;

namespace Application.Tests.Auth;

public class AuthValidatorTests
{
    private static IStringLocalizer BuildLocalizer()
    {
        var localizer = Substitute.For<IStringLocalizer>();
        localizer[Arg.Any<string>()].Returns(x => new LocalizedString(x.Arg<string>(), x.Arg<string>()));
        return localizer;
    }

    // --- LoginCommandValidator ---

    [Fact]
    public void LoginValidator_ShouldFail_WhenEmailIsEmpty()
    {
        var validator = new LoginCommandValidator(BuildLocalizer());
        var result = validator.Validate(new LoginCommand("", "Password1!", null, null, null));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "Email");
    }

    [Fact]
    public void LoginValidator_ShouldFail_WhenEmailIsMalformed()
    {
        var validator = new LoginCommandValidator(BuildLocalizer());
        var result = validator.Validate(new LoginCommand("not-an-email", "Password1!", null, null, null));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "Email");
    }

    [Fact]
    public void LoginValidator_ShouldFail_WhenPasswordIsEmpty()
    {
        var validator = new LoginCommandValidator(BuildLocalizer());
        var result = validator.Validate(new LoginCommand("user@example.com", "", null, null, null));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "Password");
    }

    [Fact]
    public void LoginValidator_ShouldPass_WithValidInput()
    {
        var validator = new LoginCommandValidator(BuildLocalizer());
        var result = validator.Validate(new LoginCommand("user@example.com", "Password1!", null, null, null));
        result.IsValid.Should().BeTrue();
    }

    // --- RegisterCommandValidator ---

    [Fact]
    public void RegisterValidator_ShouldFail_WhenEmailIsInvalid()
    {
        var validator = new RegisterCommandValidator(BuildLocalizer());
        var result = validator.Validate(new RegisterCommand("bad-email", "Password1!", "Acme"));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "Email");
    }

    [Fact]
    public void RegisterValidator_ShouldFail_WhenPasswordIsTooShort()
    {
        var validator = new RegisterCommandValidator(BuildLocalizer());
        var result = validator.Validate(new RegisterCommand("user@example.com", "short", "Acme"));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "Password");
    }

    [Fact]
    public void RegisterValidator_ShouldFail_WhenAccountNameExceedsMaxLength()
    {
        var validator = new RegisterCommandValidator(BuildLocalizer());
        var longName = new string('A', 101);
        var result = validator.Validate(new RegisterCommand("user@example.com", "Password1!", longName));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "AccountName");
    }

    [Fact]
    public void RegisterValidator_ShouldFail_WhenFieldsAreEmpty()
    {
        var validator = new RegisterCommandValidator(BuildLocalizer());
        var result = validator.Validate(new RegisterCommand("", "", ""));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().HaveCountGreaterThan(1);
    }

    [Fact]
    public void RegisterValidator_ShouldPass_WithValidInput()
    {
        var validator = new RegisterCommandValidator(BuildLocalizer());
        var result = validator.Validate(new RegisterCommand("user@example.com", "Password1!", "Acme Corp"));
        result.IsValid.Should().BeTrue();
    }

    // --- ChangePasswordCommandValidator ---

    [Fact]
    public void ChangePasswordValidator_ShouldFail_WhenOldPasswordIsEmpty()
    {
        var validator = new ChangePasswordCommandValidator(BuildLocalizer());
        var result = validator.Validate(new ChangePasswordCommand(1, "", "NewPass1!"));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "OldPassword");
    }

    [Fact]
    public void ChangePasswordValidator_ShouldFail_WhenNewPasswordIsEmpty()
    {
        var validator = new ChangePasswordCommandValidator(BuildLocalizer());
        var result = validator.Validate(new ChangePasswordCommand(1, "OldPass1!", ""));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "NewPassword");
    }

    [Fact]
    public void ChangePasswordValidator_ShouldPass_WithValidInput()
    {
        var validator = new ChangePasswordCommandValidator(BuildLocalizer());
        var result = validator.Validate(new ChangePasswordCommand(1, "OldPass1!", "NewPass1!"));
        result.IsValid.Should().BeTrue();
    }

    // --- ResetPasswordCommandValidator ---

    [Fact]
    public void ResetPasswordValidator_ShouldFail_WhenTokenIsEmpty()
    {
        var validator = new ResetPasswordCommandValidator(BuildLocalizer());
        var result = validator.Validate(new ResetPasswordCommand("user@example.com", "", "NewPass1!"));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "Token");
    }

    [Fact]
    public void ResetPasswordValidator_ShouldFail_WhenEmailIsEmpty()
    {
        var validator = new ResetPasswordCommandValidator(BuildLocalizer());
        var result = validator.Validate(new ResetPasswordCommand("", "some-token", "NewPass1!"));
        result.IsValid.Should().BeFalse();
        result.Errors.Should().Contain(e => e.PropertyName == "Email");
    }

    [Fact]
    public void ResetPasswordValidator_ShouldPass_WithValidInput()
    {
        var validator = new ResetPasswordCommandValidator(BuildLocalizer());
        var result = validator.Validate(new ResetPasswordCommand("user@example.com", "some-token", "NewPass1!"));
        result.IsValid.Should().BeTrue();
    }
}
