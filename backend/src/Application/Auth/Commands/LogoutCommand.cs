using Domain;
using MediatR;

namespace Application.Auth.Commands;

public record LogoutCommand(string RefreshToken) : IRequest<Result>;
