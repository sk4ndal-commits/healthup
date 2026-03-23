using Application.Interfaces;
using Application.Todos.Commands;
using Application.Todos.Handlers;
using Domain;
using FluentAssertions;
using NSubstitute;

namespace Application.Tests.Todos;

public class CreateTodoHandlerTests
{
    private readonly ITodoService _todoService = Substitute.For<ITodoService>();
    private readonly ICurrentUserService _currentUserService = Substitute.For<ICurrentUserService>();
    private readonly CreateTodoHandler _sut;

    public CreateTodoHandlerTests()
    {
        _currentUserService.AccountId.Returns(1);
        _sut = new CreateTodoHandler(_todoService, _currentUserService);
    }

    [Fact]
    public async Task Handle_ShouldCallCreateAsync_WithCorrectTitleAndActor()
    {
        var command = new CreateTodoCommand("Buy milk", "user@example.com");
        var expected = new TodoItem { Id = 1, Title = "Buy milk", IsDone = false };
        _todoService.CreateAsync(Arg.Any<TodoItem>(), command.ActorEmail).Returns(expected);

        var result = await _sut.Handle(command, CancellationToken.None);

        result.Should().BeEquivalentTo(expected);
        await _todoService.Received(1).CreateAsync(
            Arg.Is<TodoItem>(t => t.Title == "Buy milk" && !t.IsDone),
            "user@example.com");
    }
}
