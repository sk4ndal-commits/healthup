.PHONY: help dev build test test-parallel migrate seed format lint docker-up docker-down docker-build \
	mobile-install mobile-dev mobile-build mobile-test mobile-gen-client \
	swagger-export frontend-gen-client

BACKEND_DIR := backend
FRONTEND_DIR := frontend
MOBILE_DIR   := mobile
OPS_DIR     := ops

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

# ── Backend ──────────────────────────────────────────────────────────────────

build: ## Build the .NET solution
	cd $(BACKEND_DIR) && dotnet build Template.sln -c Release

test: ## Run all .NET test projects in parallel (~3× faster)
	@cd $(BACKEND_DIR) && \
	  (dotnet test tests/Application.Tests/Application.Tests.csproj -c Release --no-build --logger "console;verbosity=normal" & \
	   dotnet test tests/Infrastructure.Tests/Infrastructure.Tests.csproj -c Release --no-build --logger "console;verbosity=normal" & \
	   dotnet test tests/Api.Tests/Api.Tests.csproj -c Release --no-build --logger "console;verbosity=normal" & \
	   wait) && echo "All test projects finished."

migrate: ## Apply EF Core migrations (requires running DB)
	cd $(BACKEND_DIR) && dotnet ef database update --project src/Infrastructure --startup-project src/Host

seed: ## Run the API in Development mode (auto-seeds demo data on startup)
	cd $(BACKEND_DIR) && ASPNETCORE_ENVIRONMENT=Development dotnet run --project src/Host

format: ## Auto-format .NET code with dotnet-format
	cd $(BACKEND_DIR) && dotnet format Template.sln

format-check: ## Check .NET formatting without applying changes (used in CI)
	cd $(BACKEND_DIR) && dotnet format Template.sln --verify-no-changes

swagger-export: ## Export the latest Swagger JSON from the backend
	@echo "Exporting Swagger JSON..."
	@mkdir -p docs
	cd $(BACKEND_DIR) && dotnet test tests/Api.Tests/Api.Tests.csproj --filter SwaggerExportTests --logger "console;verbosity=normal"
	@cp $(BACKEND_DIR)/docs/swagger.json docs/swagger.json
	@echo "Swagger exported to docs/swagger.json"

# ── Frontend ─────────────────────────────────────────────────────────────────

frontend-install: ## Install frontend npm dependencies
	cd $(FRONTEND_DIR) && npm ci

frontend-dev: ## Start the Vite dev server
	cd $(FRONTEND_DIR) && npm run dev

frontend-build: ## Build the frontend for production
	cd $(FRONTEND_DIR) && npm run build

frontend-lint: ## Lint the frontend with ESLint
	cd $(FRONTEND_DIR) && npx eslint src --max-warnings 0

frontend-typecheck: ## Type-check the frontend with tsc
	cd $(FRONTEND_DIR) && npx tsc --noEmit

frontend-gen-client: swagger-export ## Generate typed TypeScript API client from OpenAPI spec
	cd $(FRONTEND_DIR) && npx openapi-typescript ../docs/swagger.json -o src/api/generated.ts

# ── Mobile (Flutter) ─────────────────────────────────────────────────────────

mobile-install: ## Install Flutter dependencies
	cd $(MOBILE_DIR) && flutter pub get

mobile-dev: ## Run the Flutter app in debug mode
	cd $(MOBILE_DIR) && flutter run

mobile-build: ## Build the Flutter app for production (Android APK)
	cd $(MOBILE_DIR) && flutter build apk --release

mobile-test: ## Run Flutter tests
	cd $(MOBILE_DIR) && flutter test

mobile-gen-client: swagger-export ## Generate Flutter API client from OpenAPI spec
	@cp docs/swagger.json $(MOBILE_DIR)/swagger.json
	cd $(MOBILE_DIR) && flutter pub run build_runner build --delete-conflicting-outputs

# ── Full-stack dev ────────────────────────────────────────────────────────────

dev: docker-up ## Start DB via Docker, then set up ADB and show logs
	@echo "Setting up ADB reverse port forwarding for Android (requires connected device)..."
	-adb reverse tcp:8080 tcp:8080
	-adb reverse tcp:8081 tcp:8081
	@echo "All services are up. You can now run: cd $(MOBILE_DIR) && flutter run"
	$(MAKE) docker-logs

# ── Docker ────────────────────────────────────────────────────────────────────

docker-up: ## Start all Docker services (db, api, frontend)
	cd $(OPS_DIR) && docker compose up -d

docker-down: ## Stop all Docker services
	cd $(OPS_DIR) && docker compose down

docker-build: ## Rebuild all Docker images
	cd $(OPS_DIR) && docker compose build

docker-logs: ## Tail logs from all Docker services
	cd $(OPS_DIR) && docker compose logs -f
