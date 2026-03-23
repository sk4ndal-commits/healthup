# Secrets & Environment Variables

This document lists all required environment variables and describes how to manage them across environments.

---

## Required Variables

| Variable | Description | Example |
|---|---|---|
| `DB_HOST` | PostgreSQL host | `db` (Docker) / `localhost` |
| `DB_PORT` | PostgreSQL port | `5432` |
| `DB_NAME` | Database name | `app_template` |
| `DB_USER` | Database username | `app` |
| `DB_PASSWORD` | Database password | *(secret)* |
| `JWT_SECRET` | HS256 signing key (≥32 chars) | *(secret)* |
| `JWT_ISSUER` | JWT issuer claim | `AppTemplate` |
| `JWT_AUDIENCE` | JWT audience claim | `AppTemplateUsers` |
| `CORS_ALLOWED_ORIGINS` | Comma-separated frontend origins | `https://app.example.com` |
| `SMTP_HOST` | SMTP server hostname | `smtp.sendgrid.net` |
| `SMTP_USER` | SMTP username | `apikey` |
| `SMTP_PASSWORD` | SMTP password / API key | *(secret)* |
| `SMTP_FROM_EMAIL` | Sender email address | `noreply@example.com` |
| `SMTP_FROM_NAME` | Sender display name | `App Template` |

---

## Local Development

Use `appsettings.json` (already gitignored for secrets) or .NET User Secrets:

```bash
cd backend/src/Host
dotnet user-secrets init
dotnet user-secrets set "JwtSettings:Secret" "your-local-dev-secret-32-chars-min"
dotnet user-secrets set "ConnectionStrings:Default" "Host=localhost;Port=5432;Database=app_template;Username=app;Password=app"
```

User secrets are stored in `~/.microsoft/usersecrets/<guid>/secrets.json` and never committed to git.

---

## Docker Compose (local stack)

Pass secrets via environment variables or a `.env` file in `ops/`:

```bash
# ops/.env  (never commit this file)
DB_PASSWORD=supersecret
JWT_SECRET=a-very-long-and-secure-secret-key-for-jwt-signing
SMTP_PASSWORD=your-smtp-api-key
```

Then reference them in `ops/docker-compose.yml`:

```yaml
environment:
  - ConnectionStrings__Default=Host=db;Port=5432;Database=${DB_NAME};Username=${DB_USER};Password=${DB_PASSWORD}
  - JwtSettings__Secret=${JWT_SECRET}
```

---

## Production: GitHub Actions

Store secrets in **Settings → Secrets and variables → Actions**:

| Secret name | Maps to |
|---|---|
| `DB_PASSWORD` | `DB_PASSWORD` |
| `JWT_SECRET` | `JWT_SECRET` |
| `SMTP_PASSWORD` | `SMTP_PASSWORD` |

Reference in workflow:

```yaml
env:
  JWT_SECRET: ${{ secrets.JWT_SECRET }}
  DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
```

---

## Production: Azure Key Vault

1. Install the NuGet package:
   ```bash
   dotnet add package Azure.Extensions.AspNetCore.Configuration.Secrets
   ```

2. Wire up in `Program.cs`:
   ```csharp
   if (builder.Environment.IsProduction())
   {
       var keyVaultUri = new Uri($"https://{builder.Configuration["KeyVaultName"]}.vault.azure.net/");
       builder.Configuration.AddAzureKeyVault(keyVaultUri, new DefaultAzureCredential());
   }
   ```

3. Map Key Vault secret names to ASP.NET config keys using `--` as separator:
   - `JwtSettings--Secret` → `JwtSettings:Secret`
   - `ConnectionStrings--Default` → `ConnectionStrings:Default`

---

## Production: AWS Secrets Manager

1. Install the NuGet package:
   ```bash
   dotnet add package Kralizek.Extensions.Configuration.AWSSecretsManager
   ```

2. Wire up in `Program.cs`:
   ```csharp
   if (builder.Environment.IsProduction())
   {
       builder.Configuration.AddSecretsManager(region: RegionEndpoint.EUWest1, configurator: opts =>
       {
           opts.SecretFilter = entry => entry.Name.StartsWith("app-template/");
           opts.KeyGenerator = (_, s) => s.Replace("app-template/", "").Replace("__", ":");
       });
   }
   ```

---

## Docker Secrets (Swarm / Compose v3)

For Docker Swarm deployments, use native Docker secrets:

```yaml
secrets:
  jwt_secret:
    external: true
  db_password:
    external: true

services:
  api:
    secrets:
      - jwt_secret
      - db_password
    environment:
      - JwtSettings__Secret_FILE=/run/secrets/jwt_secret
```

Read file-based secrets in `Program.cs`:

```csharp
var jwtSecret = Environment.GetEnvironmentVariable("JwtSettings__Secret_FILE") is { } path
    ? File.ReadAllText(path).Trim()
    : builder.Configuration["JwtSettings:Secret"];
```

---

## Security Checklist

- [ ] `appsettings.Production.json` contains **no real secrets** — only `${PLACEHOLDER}` values
- [ ] `.env` files are listed in `.gitignore`
- [ ] `JWT_SECRET` is at least 32 characters and randomly generated
- [ ] Database password is unique per environment
- [ ] SMTP credentials use an API key (not a personal password)
- [ ] Key Vault / Secrets Manager access uses Managed Identity (no stored credentials)
