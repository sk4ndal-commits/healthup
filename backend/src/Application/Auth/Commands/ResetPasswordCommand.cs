using Domain;
using MediatR;

namespace Application.Auth.Commands;

public record ResetPasswordCommand(string Email, string Token, string NewPassword) : IRequest<Result>;
