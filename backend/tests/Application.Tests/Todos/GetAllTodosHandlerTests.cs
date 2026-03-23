using Application.Interfaces;
using Application.Todos.Handlers;
using Application.Todos.Queries;
using Domain;
using FluentAssertions;
using NSubstitute;

namespace Application.Tests.Todos;

public class GetAllTodosHandlerTests
{
    private readonly ITodoService _todoService = Substitute.For<ITodoService>();
    private readonly GetAllTodosHandler _sut;

    public GetAllTodosHandlerTests()
    {
        _sut = new GetAllTodosHandler(_todoService);
    }

    [Fact]
    public async Task Handle_ShouldReturnAllTodos()
    {
        var todos = new List<TodoItem>
        {
            new() { Id = 1, Title = "First", IsDone = false },
            new() { Id = 2, Title = "Second", IsDone = true },
        };
        _todoService.GetAllAsync().Returns(todos);

        var result = await _sut.Handle(new GetAllTodosQuery(), CancellationToken.None);

        result.Should().BeEquivalentTo(todos);
        await _todoService.Received(1).GetAllAsync();
    }

    [Fact]
    public async Task Handle_ShouldReturnEmpty_WhenNoTodosExist()
    {
        _todoService.GetAllAsync().Returns(Enumerable.Empty<TodoItem>());

        var result = await _sut.Handle(new GetAllTodosQuery(), CancellationToken.None);

        result.Should().BeEmpty();
    }
}
