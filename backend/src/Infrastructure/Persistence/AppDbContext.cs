using Application.Interfaces;
using Domain;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Persistence;

public class AppDbContext : DbContext
{
    private readonly ICurrentUserService _currentUserService;

    public AppDbContext(DbContextOptions<AppDbContext> options, ICurrentUserService currentUserService) : base(options)
    {
        _currentUserService = currentUserService;
    }

    public DbSet<User> Users => Set<User>();
    public DbSet<Account> Accounts => Set<Account>();
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();
    public DbSet<AuditLog> AuditLogs => Set<AuditLog>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<AuditLog>(eb =>
        {
            eb.HasKey(e => e.Id);
            eb.Property(e => e.Action).IsRequired().HasMaxLength(100);
            eb.Property(e => e.ActorEmail).HasMaxLength(256);
            eb.Property(e => e.EntityType).HasMaxLength(100);
            eb.Property(e => e.EntityId).HasMaxLength(100);
            eb.Property(e => e.MetadataJson).HasColumnType("jsonb");
            eb.Property(e => e.TimestampUtc).IsRequired();
        });

        modelBuilder.Entity<RefreshToken>(eb =>
        {
            eb.HasKey(e => e.Id);
            eb.Property(e => e.Token).IsRequired().HasMaxLength(200);
            eb.HasIndex(e => e.Token).IsUnique();
            eb.Property(e => e.DeviceId).HasMaxLength(200);
            eb.Property(e => e.UserAgent).HasMaxLength(500);
            eb.Property(e => e.IpAddress).HasMaxLength(50);
            eb.Property(e => e.CreatedAtUtc).IsRequired();
            eb.Property(e => e.ExpiresAtUtc).IsRequired();

            eb.HasOne(e => e.User)
                .WithMany()
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            eb.HasQueryFilter(t => t.AccountId == (_currentUserService.AccountId ?? 0));
        });

        modelBuilder.Entity<Account>(eb =>
        {
            eb.HasKey(e => e.Id);
            eb.Property(e => e.Name).IsRequired().HasMaxLength(200);
            eb.Property(e => e.CreatedAtUtc).IsRequired();
        });

        modelBuilder.Entity<User>(eb =>
        {
            eb.HasKey(e => e.Id);
            eb.Property(e => e.Email).IsRequired().HasMaxLength(256);
            eb.HasIndex(e => e.Email).IsUnique();
            eb.Property(e => e.PasswordHash).IsRequired();
            eb.Property(e => e.Role).IsRequired().HasMaxLength(50);
            eb.Property(e => e.CreatedAtUtc).IsRequired();
            eb.Property(e => e.PasswordResetToken).HasMaxLength(200);
            eb.Property(e => e.PasswordResetTokenExpiresUtc);

            eb.HasOne(e => e.Account)
                .WithMany(e => e.Users)
                .HasForeignKey(e => e.AccountId)
                .OnDelete(DeleteBehavior.Cascade);

            eb.HasQueryFilter(u => u.AccountId == (_currentUserService.AccountId ?? 0));
        });

    }
}
