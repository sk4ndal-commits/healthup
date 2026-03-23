using System.Text.Json;
using Application.Interfaces;
using Domain;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Persistence;


public class TodoService : ITodoService
{
    private readonly AppDbContext _context;
    private readonly IAuditService _auditService;

    public TodoService(AppDbContext context, IAuditService auditService)
    {
        _context = context;
        _auditService = auditService;
    }

    public async Task<IEnumerable<TodoItem>> GetAllAsync()
    {
        return await _context.TodoItems
            .OrderByDescending(t => t.CreatedAt)
            .ToListAsync();
    }

    public async Task<TodoItem?> GetByIdAsync(int id)
    {
        return await _context.TodoItems
            .FirstOrDefaultAsync(t => t.Id == id);
    }

    public async Task<TodoItem> CreateAsync(TodoItem todo, string actorEmail)
    {
        todo.CreatedAt = DateTime.UtcNow;
        _context.TodoItems.Add(todo);
        await _context.SaveChangesAsync(); // Save to get the ID

        await _auditService.LogAsync("CreateTodo", actorEmail, "TodoItem", todo.Id.ToString(), todo);

        return todo;
    }

    public async Task<bool> UpdateAsync(TodoItem todo, string actorEmail)
    {
        var existing = await _context.TodoItems
            .FirstOrDefaultAsync(t => t.Id == todo.Id);
        if (existing == null) return false;

        existing.Title = todo.Title;
        existing.IsDone = todo.IsDone;
        existing.DueDate = todo.DueDate;

        await _auditService.LogAsync("UpdateTodo", actorEmail, "TodoItem", todo.Id.ToString(), todo);

        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<bool> DeleteAsync(int id, string actorEmail)
    {
        var todo = await _context.TodoItems
            .FirstOrDefaultAsync(t => t.Id == id);
        if (todo == null) return false;

        _context.TodoItems.Remove(todo);

        await _auditService.LogAsync("DeleteTodo", actorEmail, "TodoItem", id.ToString(), todo);

        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<bool> ToggleDoneAsync(int id, string actorEmail)
    {
        var todo = await _context.TodoItems
            .FirstOrDefaultAsync(t => t.Id == id);
        if (todo == null) return false;

        todo.IsDone = !todo.IsDone;

        await _auditService.LogAsync("ToggleTodoDone", actorEmail, "TodoItem", id.ToString(), new { IsDone = todo.IsDone });

        await _context.SaveChangesAsync();
        return true;
    }
}
