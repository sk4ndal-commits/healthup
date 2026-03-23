using Domain;
using Infrastructure.Persistence;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace Host.Extensions;

public static class WebApplicationExtensions
{
    public static WebApplication UseSeedData(this WebApplication app)
    {
        if (!app.Environment.IsDevelopment()) return app;
        using var scope = app.Services.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<AppDbContext>();

        if (context.Database.ProviderName != "Microsoft.EntityFrameworkCore.InMemory")
            context.Database.Migrate();
        else
            context.Database.EnsureCreated();

        if (context.Users.IgnoreQueryFilters().Any(u => u.Email == "admin@local")) return app;

        SeedDemoData(context);
        return app;
    }

    private static void SeedDemoData(AppDbContext context)
    {
        var hasher = new PasswordHasher<User>();

        // ── Accounts (tenants) ────────────────────────────────────────────────
        var adminAccount = new Account { Name = "System Admin Account", CreatedAtUtc = DateTime.UtcNow };
        var acmeAccount = new Account { Name = "Acme Corp", CreatedAtUtc = DateTime.UtcNow };
        var betaAccount = new Account { Name = "Beta Startup", CreatedAtUtc = DateTime.UtcNow };
        context.Accounts.AddRange(adminAccount, acmeAccount, betaAccount);
        context.SaveChanges();

        // ── Users ─────────────────────────────────────────────────────────────
        var admin = new User
        {
            Email = "admin@local",
            Role = "Admin",
            IsActive = true,
            CreatedAtUtc = DateTime.UtcNow,
            AccountId = adminAccount.Id
        };
        admin.PasswordHash = hasher.HashPassword(admin, "Admin123!");

        var acmeUser = new User
        {
            Email = "user@acme.local",
            Role = "AppUser",
            IsActive = true,
            CreatedAtUtc = DateTime.UtcNow,
            AccountId = acmeAccount.Id
        };
        acmeUser.PasswordHash = hasher.HashPassword(acmeUser, "User123!");

        var betaUser = new User
        {
            Email = "user@beta.local",
            Role = "AppUser",
            IsActive = true,
            CreatedAtUtc = DateTime.UtcNow,
            AccountId = betaAccount.Id
        };
        betaUser.PasswordHash = hasher.HashPassword(betaUser, "User123!");

        context.Users.AddRange(admin, acmeUser, betaUser);
        context.SaveChanges();

        // ── Todo items (per tenant) ───────────────────────────────────────────
        var acmeTodos = new[]
        {
            new TodoItem { Title = "Set up CI/CD pipeline",      IsDone = true,  CreatedAt = DateTime.UtcNow.AddDays(-10), AccountId = acmeAccount.Id },
            new TodoItem { Title = "Write API documentation",    IsDone = false, CreatedAt = DateTime.UtcNow.AddDays(-7),  AccountId = acmeAccount.Id },
            new TodoItem { Title = "Implement user onboarding",  IsDone = false, CreatedAt = DateTime.UtcNow.AddDays(-3),  AccountId = acmeAccount.Id },
            new TodoItem { Title = "Review security checklist",  IsDone = false, CreatedAt = DateTime.UtcNow.AddDays(-1),  AccountId = acmeAccount.Id },
        };

        var betaTodos = new[]
        {
            new TodoItem { Title = "Define MVP feature set",     IsDone = true,  CreatedAt = DateTime.UtcNow.AddDays(-5),  AccountId = betaAccount.Id },
            new TodoItem { Title = "Design database schema",     IsDone = true,  CreatedAt = DateTime.UtcNow.AddDays(-4),  AccountId = betaAccount.Id },
            new TodoItem { Title = "Build landing page",         IsDone = false, CreatedAt = DateTime.UtcNow.AddDays(-2),  AccountId = betaAccount.Id },
        };

        context.TodoItems.AddRange(acmeTodos);
        context.TodoItems.AddRange(betaTodos);
        context.SaveChanges();
    }
}
