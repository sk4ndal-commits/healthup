using Domain;
using MediatR;

namespace Application.Todos.Commands;

public record ToggleTodoCommand(int Id, string ActorEmail) : IRequest<Result>;
