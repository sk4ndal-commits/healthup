using Domain;
using MediatR;

namespace Application.Auth.Commands;

public record ForgotPasswordCommand(string Email) : IRequest<Result>;
