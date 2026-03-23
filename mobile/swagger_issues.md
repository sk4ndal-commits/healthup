### Summary of Swagger & API Generation Issues

The current API generation workflow in the HealthUp project has several architectural and operational weaknesses that lead to frequent build breakages and developer friction.

#### 1. Identified Issues

- **Fragile Backend Export**: The `swagger.json` export depends on `dotnet test` running a specific `SwaggerExportTests`. This test requires a fully compilable backend and often fails if database migrations are out of sync or if there are startup configuration errors.
- **Dart SDK Version Mismatch**: The generated `api_client` Flutter package defaults to an older Dart SDK constraint (`>=2.15.0`) while the main `mobile` project uses `>=3.11.0`. This causes "language version override" errors during compilation.
- **Stale Artifacts**: The `Makefile` does not always clean up old generated files, leading to conflicts (e.g., `build_runner` failing due to conflicting outputs).
- **Inconsistent Generators**:
    - **Frontend**: Uses `openapi-typescript` (Node.js).
    - **Mobile**: Uses `openapi-generator` (Java-based via Flutter wrapper) with a custom JAR.
    - These generators sometimes interpret the same OpenAPI spec differently, leading to subtle bugs between platforms.
- **Manual Syncing**: The `Makefile` partially automates the flow, but it still requires the backend to be in a "testable" state. If the backend is broken, frontend and mobile developers are blocked from updating their clients.
- **Missing Metadata**: The OpenAPI spec often lacks critical information (like `LoginResponse` schemas), which was recently identified as a cause for silent login failures on mobile.

#### 2. Proposed Improvements

- **Centralized Schema Source**: Decouple Swagger generation from the running backend code.
    - **Option A**: Use a static `openapi.yaml/json` as the source of truth (Design-First).
    - **Option B**: Improve `dotnet swagger` CLI usage in the `Makefile` to generate the spec without running the full test suite.
- **Standardized Generator Configuration**:
    - Use a single `spectral` or `openapi-lint` tool to validate the spec before generation.
    - Explicitly set the Dart SDK version in the `openapi-generator` configuration to match the project's SDK.
- **Automated "Clean & Generate"**:
    - Update `Makefile` to always perform a clean step before generation.
    - Include a verification step that runs `flutter analyze` and `npm run typecheck` immediately after generation.
- **CI/CD Integration**:
    - Automate the export and client generation in a CI pipeline.
    - If the OpenAPI spec changes, automatically create a PR with the updated clients.
- **Contract Testing**:
    - Implement basic contract tests to ensure the backend actually adheres to the exported `swagger.json`.

#### 3. Recommended Action Plan

1.  **Fix Dart Generator Config**: Update `openapi_generator_config.json` to include `pubContext` or post-generation scripts that align the `pubspec.yaml` of the generated package with the main app.
2.  **Robust Export**: Replace the `dotnet test` based export with a dedicated `dotnet run --project src/Host --swagger` command or a specialized tool that doesn't rely on the test runner.
3.  **Unified Makefile**: Consolidate `frontend-gen-client` and `mobile-gen-client` into a single `gen-clients` command that ensures the `swagger.json` is fresh and all platforms are updated simultaneously.
