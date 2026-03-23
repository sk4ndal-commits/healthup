using Application.Auth.Commands;
using Application.Auth.Handlers;
using Application.Interfaces;
using Domain.Events;
using FluentAssertions;
using Microsoft.Extensions.Localization;
using NSubstitute;

namespace Application.Tests.Auth;

public class RegisterHandlerTests
{
    private readonly IIdentityService _identityService = Substitute.For<IIdentityService>();
    private readonly IDomainEventDispatcher _eventDispatcher = Substitute.For<IDomainEventDispatcher>();
    private readonly IStringLocalizer _localizer = Substitute.For<IStringLocalizer>();
    private readonly RegisterHandler _sut;

    public RegisterHandlerTests()
    {
        _localizer["EmailAlreadyInUse"].Returns(new LocalizedString("EmailAlreadyInUse", "Email already in use."));
        _sut = new RegisterHandler(_identityService, _eventDispatcher, _localizer);
    }

    [Fact]
    public async Task Handle_ShouldReturnSuccess_AndDispatchEvent_WhenRegistrationSucceeds()
    {
        var command = new RegisterCommand("new@example.com", "Password1!", "Acme Corp");
        _identityService.RegisterAsync(command.Email, command.Password, command.AccountName).Returns(true);

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeTrue();
        await _eventDispatcher.Received(1).DispatchAsync(
            Arg.Is<TenantRegisteredEvent>(e => e.OwnerEmail == command.Email && e.AccountName == command.AccountName),
            Arg.Any<CancellationToken>());
    }

    [Fact]
    public async Task Handle_ShouldReturnFailure_WhenEmailAlreadyInUse()
    {
        var command = new RegisterCommand("existing@example.com", "Password1!", "Acme Corp");
        _identityService.RegisterAsync(command.Email, command.Password, command.AccountName).Returns(false);

        var result = await _sut.Handle(command, CancellationToken.None);

        result.IsSuccess.Should().BeFalse();
        result.Error.Should().Be("Email already in use.");
        await _eventDispatcher.DidNotReceive().DispatchAsync(Arg.Any<IDomainEvent>(), Arg.Any<CancellationToken>());
    }
}
