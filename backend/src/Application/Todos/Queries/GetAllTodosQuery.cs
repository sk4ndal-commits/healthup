using Domain;
using MediatR;

namespace Application.Todos.Queries;

public record GetAllTodosQuery : IRequest<IEnumerable<TodoItem>>;
