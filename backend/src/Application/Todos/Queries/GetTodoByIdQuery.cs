using Domain;
using MediatR;

namespace Application.Todos.Queries;

public record GetTodoByIdQuery(int Id) : IRequest<TodoItem?>;
