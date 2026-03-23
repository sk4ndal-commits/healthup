using Application.Interfaces;
using Application.Todos.Commands;
using Domain;
using MediatR;

namespace Application.Todos.Handlers;

public class DeleteTodoHandler(ITodoService todoService) : IRequestHandler<DeleteTodoCommand, Result>
{
    public async Task<Result> Handle(DeleteTodoCommand request, CancellationToken cancellationToken)
    {
        var success = await todoService.DeleteAsync(request.Id, request.ActorEmail);
        return success ? Result.Success() : Result.Failure("Todo not found");
    }
}
