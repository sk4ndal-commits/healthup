using Domain;

namespace Application.Interfaces;

public interface ITodoService
{
    Task<IEnumerable<TodoItem>> GetAllAsync();
    Task<TodoItem?> GetByIdAsync(int id);
    Task<TodoItem> CreateAsync(TodoItem todo, string actorEmail);
    Task<bool> UpdateAsync(TodoItem todo, string actorEmail);
    Task<bool> DeleteAsync(int id, string actorEmail);
    Task<bool> ToggleDoneAsync(int id, string actorEmail);
}
