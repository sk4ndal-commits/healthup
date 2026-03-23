# App Factory Template

A production-ready, multi-tenant SaaS starter built on **.NET 8** (Clean Architecture) with a decoupled **React** frontend.

## Project Structure

```bash
app-factory-template/
├── backend/          # .NET 8 Web API (Clean Architecture)
│   ├── src/          # Application source code
│   └── tests/        # Unit, Integration, and API tests
├── frontend/         # React (Vite / TypeScript / Tailwind CSS)
├── mobile/           # Flutter (iOS / Android)
├── docs/             # Architecture docs and guides
├── ops/              # Infrastructure / DevOps (Docker Compose)
├── Makefile          # Unified task runner for dev, build, and test
└── todo.md           # Implementation and improvement roadmap
```

## Quick Start (using Makefile)

The project uses a `Makefile` to simplify common development tasks.

```bash
# 1. Spin up the infrastructure (PostgreSQL)
make docker-up

# 2. Apply database migrations
make migrate

# 3. Seed demo data and start the API
make seed

# 4. In a separate terminal, start the frontend
make frontend-install
make frontend-dev
```

Run `make help` to see all available commands.

## Getting Started (Manual)

### Prerequisites

- [.NET 8 SDK](https://dotnet.microsoft.com/download)
- [Docker](https://www.docker.com/) (for PostgreSQL)
- [Node.js 20+](https://nodejs.org/)
- [Flutter SDK](https://docs.flutter.dev/get-started/install)

### Run the backend

```bash
# 1. Start the database
cd ops && docker compose up -d

# 2. Apply EF Core migrations
cd backend && dotnet ef database update --project src/Infrastructure --startup-project src/Host

# 3. Run the API
dotnet run --project src/Host/Host.csproj
```

### Run the frontend

```bash
cd frontend
npm install
npm run dev
```

## Development Tasks

| Task | Backend | Frontend | Mobile |
| :--- | :--- | :--- | :--- |
| **Build** | `make build` | `make frontend-build` | `make mobile-build` |
| **Test** | `make test` | `make frontend-typecheck` | `make mobile-test` |
| **Lint/Format** | `make format` | `make frontend-lint` | - |
| **API Client** | - | `make frontend-gen-client` | `make mobile-gen-client` |

## Documentation

- [`summarize.md`](./summarize.md) — project architecture and overview
- [`todo.md`](./todo.md) — step-by-step roadmap and improvement checklist
- [`add_mobile.md`](./add_mobile.md) — mobile app integration and architecture guide
- [`start_mobile.md`](./start_mobile.md) — how to run and connect the mobile app
- [`backend/FUNCTIONALITY_CONTRACT.md`](./backend/FUNCTIONALITY_CONTRACT.md) — feature contract for all derived apps
- [`docs/secrets.md`](./docs/secrets.md) — secrets management guide
