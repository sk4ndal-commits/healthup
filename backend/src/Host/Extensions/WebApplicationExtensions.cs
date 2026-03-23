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
    }
}
