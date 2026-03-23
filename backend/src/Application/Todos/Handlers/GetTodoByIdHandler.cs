using Application.Interfaces;
using Application.Todos.Queries;
using Domain;
using MediatR;

namespace Application.Todos.Handlers;

public class GetTodoByIdHandler(ITodoService todoService) : IRequestHandler<GetTodoByIdQuery, TodoItem?>
{
    public Task<TodoItem?> Handle(GetTodoByIdQuery request, CancellationToken cancellationToken)
        => todoService.GetByIdAsync(request.Id);
}
