using Application.Interfaces;
using Domain;
using FluentAssertions;
using Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using NSubstitute;

namespace Infrastructure.Tests.Persistence;

public class TodoServiceTests : IDisposable
{
    private readonly AppDbContext _context;
    private readonly IAuditService _auditService = Substitute.For<IAuditService>();
    private readonly TodoService _sut;

    public TodoServiceTests()
    {
        var currentUser = Substitute.For<ICurrentUserService>();
        currentUser.AccountId.Returns(0);

        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;

        _context = new AppDbContext(options, currentUser);
        _sut = new TodoService(_context, _auditService);
    }

    public void Dispose() => _context.Dispose();

    [Fact]
    public async Task CreateAsync_ShouldPersistTodoAndReturnWithId()
    {
        var todo = new TodoItem { Title = "Test todo", IsDone = false };

        var result = await _sut.CreateAsync(todo, "actor@example.com");

        result.Id.Should().BeGreaterThan(0);
        result.Title.Should().Be("Test todo");
        result.CreatedAt.Should().BeCloseTo(DateTime.UtcNow, TimeSpan.FromSeconds(5));
        _context.TodoItems.Should().ContainSingle();
    }

    [Fact]
    public async Task GetAllAsync_ShouldReturnAllPersistedTodos()
    {
        _context.TodoItems.AddRange(
            new TodoItem { Title = "A", IsDone = false, CreatedAt = DateTime.UtcNow.AddMinutes(-2) },
            new TodoItem { Title = "B", IsDone = true, CreatedAt = DateTime.UtcNow.AddMinutes(-1) });
        await _context.SaveChangesAsync();

        var result = await _sut.GetAllAsync();

        result.Should().HaveCount(2);
    }

    [Fact]
    public async Task GetByIdAsync_ShouldReturnCorrectTodo()
    {
        var todo = new TodoItem { Title = "Find me", IsDone = false, CreatedAt = DateTime.UtcNow };
        _context.TodoItems.Add(todo);
        await _context.SaveChangesAsync();

        var result = await _sut.GetByIdAsync(todo.Id);

        result.Should().NotBeNull();
        result!.Title.Should().Be("Find me");
    }

    [Fact]
    public async Task GetByIdAsync_ShouldReturnNull_WhenNotFound()
    {
        var result = await _sut.GetByIdAsync(999);
        result.Should().BeNull();
    }

    [Fact]
    public async Task UpdateAsync_ShouldModifyExistingTodo()
    {
        var todo = new TodoItem { Title = "Old title", IsDone = false, CreatedAt = DateTime.UtcNow };
        _context.TodoItems.Add(todo);
        await _context.SaveChangesAsync();

        var updated = new TodoItem { Id = todo.Id, Title = "New title", IsDone = true };
        var result = await _sut.UpdateAsync(updated, "actor@example.com");

        result.Should().BeTrue();
        var persisted = await _context.TodoItems.FindAsync(todo.Id);
        persisted!.Title.Should().Be("New title");
        persisted.IsDone.Should().BeTrue();
    }

    [Fact]
    public async Task UpdateAsync_ShouldReturnFalse_WhenTodoNotFound()
    {
        var result = await _sut.UpdateAsync(new TodoItem { Id = 999, Title = "X" }, "actor@example.com");
        result.Should().BeFalse();
    }

    [Fact]
    public async Task DeleteAsync_ShouldRemoveTodo()
    {
        var todo = new TodoItem { Title = "Delete me", IsDone = false, CreatedAt = DateTime.UtcNow };
        _context.TodoItems.Add(todo);
        await _context.SaveChangesAsync();

        var result = await _sut.DeleteAsync(todo.Id, "actor@example.com");

        result.Should().BeTrue();
        _context.TodoItems.Should().BeEmpty();
    }

    [Fact]
    public async Task DeleteAsync_ShouldReturnFalse_WhenTodoNotFound()
    {
        var result = await _sut.DeleteAsync(999, "actor@example.com");
        result.Should().BeFalse();
    }

    [Fact]
    public async Task ToggleDoneAsync_ShouldFlipIsDone()
    {
        var todo = new TodoItem { Title = "Toggle me", IsDone = false, CreatedAt = DateTime.UtcNow };
        _context.TodoItems.Add(todo);
        await _context.SaveChangesAsync();

        var result = await _sut.ToggleDoneAsync(todo.Id, "actor@example.com");

        result.Should().BeTrue();
        var persisted = await _context.TodoItems.FindAsync(todo.Id);
        persisted!.IsDone.Should().BeTrue();
    }
}
