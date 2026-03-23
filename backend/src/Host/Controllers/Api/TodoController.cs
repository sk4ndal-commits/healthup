using System.Security.Claims;
using Application.Todos.Commands;
using Application.Todos.Queries;
using Asp.Versioning;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Host.Controllers.Api;

[ApiController]
[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/[controller]")]
[Authorize(Policy = "ApiUser")]
public class TodoController(IMediator mediator) : ControllerBase
{

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var todos = await mediator.Send(new GetAllTodosQuery());
        return Ok(todos);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var todo = await mediator.Send(new GetTodoByIdQuery(id));
        if (todo == null) return NotFound();
        return Ok(todo);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] TodoCreateRequest request)
    {
        var actorEmail = User.FindFirstValue(ClaimTypes.Email) ?? "api-user";
        var result = await mediator.Send(new CreateTodoCommand(request.Title, actorEmail));
        return CreatedAtAction(nameof(GetById), new { id = result.Id }, result);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] TodoUpdateRequest request)
    {
        var actorEmail = User.FindFirstValue(ClaimTypes.Email) ?? "api-user";
        var result = await mediator.Send(new UpdateTodoCommand(id, request.Title, request.IsDone, actorEmail));
        if (!result.IsSuccess) return NotFound();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var actorEmail = User.FindFirstValue(ClaimTypes.Email) ?? "api-user";
        var result = await mediator.Send(new DeleteTodoCommand(id, actorEmail));
        if (!result.IsSuccess) return NotFound();
        return NoContent();
    }

    [HttpPost("{id:int}/toggle")]
    public async Task<IActionResult> Toggle(int id)
    {
        var actorEmail = User.FindFirstValue(ClaimTypes.Email) ?? "api-user";
        var result = await mediator.Send(new ToggleTodoCommand(id, actorEmail));
        if (!result.IsSuccess) return NotFound();
        return Ok();
    }
}

public record TodoCreateRequest(string Title);
public record TodoUpdateRequest(string Title, bool IsDone);
