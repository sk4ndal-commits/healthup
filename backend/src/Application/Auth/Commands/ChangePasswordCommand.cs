using Domain;
using MediatR;

namespace Application.Auth.Commands;

public record ChangePasswordCommand(int UserId, string OldPassword, string NewPassword) : IRequest<Result>;
