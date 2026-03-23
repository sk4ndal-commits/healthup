using Domain;
using MediatR;

namespace Application.Auth.Commands;

public record RegisterCommand(string Email, string Password, string AccountName) : IRequest<Result>;
