using Application.Interfaces;
using Application.Todos.Queries;
using Domain;
using MediatR;

namespace Application.Todos.Handlers;

public class GetAllTodosHandler(ITodoService todoService) : IRequestHandler<GetAllTodosQuery, IEnumerable<TodoItem>>
{
    public Task<IEnumerable<TodoItem>> Handle(GetAllTodosQuery request, CancellationToken cancellationToken)
        => todoService.GetAllAsync();
}
