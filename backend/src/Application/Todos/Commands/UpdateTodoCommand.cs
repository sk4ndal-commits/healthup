using Domain;
using MediatR;

namespace Application.Todos.Commands;

public record UpdateTodoCommand(int Id, string Title, bool IsDone, string ActorEmail) : IRequest<Result>;
