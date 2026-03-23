using Application.Interfaces;
using Application.Todos.Commands;
using Domain;
using MediatR;

namespace Application.Todos.Handlers;

public class ToggleTodoHandler(ITodoService todoService) : IRequestHandler<ToggleTodoCommand, Result>
{
    public async Task<Result> Handle(ToggleTodoCommand request, CancellationToken cancellationToken)
    {
        var success = await todoService.ToggleDoneAsync(request.Id, request.ActorEmail);
        return success ? Result.Success() : Result.Failure("Todo not found");
    }
}
