using Application.Interfaces;
using Domain;
using Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Infrastructure.Auth;

public class TodoReminderService : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<TodoReminderService> _logger;

    public TodoReminderService(IServiceProvider serviceProvider, ILogger<TodoReminderService> logger)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Todo Reminder Service is starting.");

        while (!stoppingToken.IsCancellationRequested)
        {
            await ProcessReminders(stoppingToken);

            // Check every hour
            await Task.Delay(TimeSpan.FromHours(1), stoppingToken);
        }

        _logger.LogInformation("Todo Reminder Service is stopping.");
    }

    public async Task ProcessReminders(CancellationToken stoppingToken)
    {
        try
        {
            using var scope = _serviceProvider.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<AppDbContext>();
            var emailSender = scope.ServiceProvider.GetRequiredService<IEmailSender>();
            var localizer = scope.ServiceProvider.GetRequiredService<Microsoft.Extensions.Localization.IStringLocalizer<TodoReminderService>>();

            // Find todos due in the next 24 hours that are not done
            var tomorrow = DateTime.UtcNow.AddDays(1);
            var upcomingTodos = await context.TodoItems
                .IgnoreQueryFilters() // Background job needs to see all tenants
                .Include(t => t.Account)
                .ThenInclude(a => a.Users)
                .Where(t => !t.IsDone && t.DueDate.HasValue && t.DueDate.Value <= tomorrow && t.DueDate.Value > DateTime.UtcNow)
                .ToListAsync(stoppingToken);

            foreach (var todo in upcomingTodos)
            {
                _logger.LogInformation("Sending reminder for Todo: {Title} in Account: {Account}", todo.Title, todo.Account.Name);

                foreach (var user in todo.Account.Users.Where(u => u.IsActive))
                {
                    await emailSender.SendEmailAsync(
                        user.Email,
                        localizer["Upcoming Todo Reminder"],
                        localizer["Reminder: Your todo '{0}' is due on {1:g}.", todo.Title, todo.DueDate!.Value].Value);
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error occurred while processing todo reminders.");
        }
    }
}
