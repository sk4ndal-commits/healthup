using Application.Interfaces;
using Application.Todos.Commands;
using Domain;
using MediatR;

namespace Application.Todos.Handlers;

public class CreateTodoHandler(ITodoService todoService, ICurrentUserService currentUserService) : IRequestHandler<CreateTodoCommand, TodoItem>
{
    public Task<TodoItem> Handle(CreateTodoCommand request, CancellationToken cancellationToken)
        => todoService.CreateAsync(new TodoItem { Title = request.Title, IsDone = false, AccountId = currentUserService.AccountId ?? 0 }, request.ActorEmail);
}
