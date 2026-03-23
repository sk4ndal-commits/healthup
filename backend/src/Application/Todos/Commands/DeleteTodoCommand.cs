using Domain;
using MediatR;

namespace Application.Todos.Commands;

public record DeleteTodoCommand(int Id, string ActorEmail) : IRequest<Result>;
