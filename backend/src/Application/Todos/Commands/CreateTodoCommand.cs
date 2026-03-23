using Domain;
using MediatR;

namespace Application.Todos.Commands;

public record CreateTodoCommand(string Title, string ActorEmail) : IRequest<TodoItem>;
