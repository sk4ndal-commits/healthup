using Application.Interfaces;
using Application.Todos.Commands;
using Domain;
using MediatR;

namespace Application.Todos.Handlers;

public class UpdateTodoHandler(ITodoService todoService) : IRequestHandler<UpdateTodoCommand, Result>
{
    public async Task<Result> Handle(UpdateTodoCommand request, CancellationToken cancellationToken)
    {
        var success = await todoService.UpdateAsync(
            new TodoItem { Id = request.Id, Title = request.Title, IsDone = request.IsDone },
            request.ActorEmail);
        return success ? Result.Success() : Result.Failure("Todo not found");
    }
}
