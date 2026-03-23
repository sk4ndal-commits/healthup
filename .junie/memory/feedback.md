[2026-03-21 22:53] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "Docker build error",
    "EXPECTATION": "The Dockerized backend should build successfully; NuGet packages (e.g., Dapper.AOT) must be restored during the image build.",
    "NEW INSTRUCTION": "WHEN user shares build logs with errors THEN diagnose root cause and propose concrete fixes"
}

[2026-03-21 22:59] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "Docker Compose CLI mismatch",
    "EXPECTATION": "The suggested 'docker compose up -d' command should work; provide instructions that match the user's installed Docker/Compose versions and enable bringing the stack up successfully.",
    "NEW INSTRUCTION": "WHEN 'docker compose up -d' errors with 'unknown shorthand flag: d' THEN provide steps to install/enable Compose v2 plugin and verify version"
}

[2026-03-21 23:32] - Updated by Junie
{
    "TYPE": "preference",
    "CATEGORY": "Developer experience tooling",
    "EXPECTATION": "Implement the Developer Experience step using a Makefile rather than a justfile.",
    "NEW INSTRUCTION": "WHEN setting up developer scripts or task runners THEN use Makefile and avoid justfile"
}

[2026-03-21 23:54] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "Docker Buildx missing",
    "EXPECTATION": "Running 'docker compose up -d --build' should work without build warnings; install and enable Buildx so images can be built via Compose.",
    "NEW INSTRUCTION": "WHEN docker compose warns \"requires buildx plugin\" THEN install docker-buildx plugin and set default builder"
}

[2026-03-21 23:57] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "Registration error",
    "EXPECTATION": "User expects to register successfully with the provided email; self-registration should be enabled and unique email checks should behave correctly.",
    "NEW INSTRUCTION": "WHEN registration fails with 'email in use or disabled' THEN request logs, verify self-registration setting, suggest fixes"
}

[2026-03-21 23:59] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "Docker Buildx exec error",
    "EXPECTATION": "User expects 'docker compose up -d --build' to work; Buildx must be correctly installed for the host architecture and the stack should recover even after an interrupted build.",
    "NEW INSTRUCTION": "WHEN build fails with \"exec format error\" for docker-buildx THEN guide reinstalling correct-arch buildx plugin and retry build"
}

[2026-03-22 00:04] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "API connectivity/port mismatch",
    "EXPECTATION": "The frontend should call the running API on the correct port; the API must be reachable from the browser without connection errors.",
    "NEW INSTRUCTION": "WHEN user reports net::ERR_CONNECTION_REFUSED to API URL THEN verify compose is up, confirm API port mapping, and update frontend base URL"
}

[2026-03-22 00:05] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "CORS preflight failure",
    "EXPECTATION": "Frontend at http://localhost:8081 should call API at http://localhost:8080 without CORS errors; preflight must succeed and the response must include Access-Control-Allow-Origin.",
    "NEW INSTRUCTION": "WHEN browser shows \"blocked by CORS policy\" THEN validate CORS policy and middleware order, allow frontend origin"
}

[2026-03-22 00:07] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "Auth UI layout/fields",
    "EXPECTATION": "Login/registration pages should not have A4-like vertical margins; registration must include a confirm password field, and password inputs should have a show/hide toggle.",
    "NEW INSTRUCTION": "WHEN building or updating auth pages THEN use full-width layout, add confirm-password and visibility toggles"
}

[2026-03-22 00:39] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "CORS policy failure",
    "EXPECTATION": "Frontend at http://localhost:8081 should call API at http://localhost:8080 without CORS errors; responses must include Access-Control-Allow-Origin.",
    "NEW INSTRUCTION": "WHEN browser shows CORS blocked from http://localhost:8081 THEN enable that origin and call UseCors before auth/endpoints"
}

[2026-03-22 00:43] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "Todo DELETE 404",
    "EXPECTATION": "DELETE /api/v1/todo/{id} should be routed and handled correctly so item deletion from the frontend works.",
    "NEW INSTRUCTION": "WHEN user reports 404 on API endpoint THEN verify route template, API versioning, and implement missing action"
}

[2026-03-22 00:55] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "Forgot-password email not sent",
    "EXPECTATION": "Submitting forgot-password should trigger and deliver a password reset email to the user.",
    "NEW INSTRUCTION": "WHEN user reports missing reset email THEN request backend logs and verify SMTP/Hangfire configuration"
}

[2026-03-22 00:59] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "Email sender selection",
    "EXPECTATION": "SMTPEmailSender should be used so real emails are sent, not a mock.",
    "NEW INSTRUCTION": "WHEN environment is not Development THEN configure and use SmtpEmailSender with SMTP env vars"
}

[2026-03-22 01:02] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "Forgot-password recipient",
    "EXPECTATION": "The forgot-password email should be sent to the email entered in the form, not to the currently logged-in user's email.",
    "NEW INSTRUCTION": "WHEN forgot-password targets current user THEN use request email payload and ignore auth context"
}

[2026-03-22 01:15] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "Frontend ESLint/Prettier",
    "EXPECTATION": "The frontend should pass linting and formatting; Prettier line breaks must be applied and react-refresh rule must be respected by exporting only components from component files.",
    "NEW INSTRUCTION": "WHEN ESLint reports react-refresh/only-export-components THEN move non-component exports to a separate module"
}

[2026-03-22 01:20] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "CI test DB dependency",
    "EXPECTATION": "API tests in GitHub Actions should pass without requiring a real Postgres; the test host must avoid starting Hangfire/PostgreSQL connections.",
    "NEW INSTRUCTION": "WHEN API tests fail with Npgsql connection refused THEN use in-memory DB and disable Hangfire in WebApplicationFactory"
}

[2026-03-22 01:25] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "API tests healthcheck",
    "EXPECTATION": "API Health endpoint tests should return 200 without requiring a real Postgres; the test host must avoid hitting Npgsql and Hangfire during CI.",
    "NEW INSTRUCTION": "WHEN API tests log \"Failed to connect to 127.0.0.1:5432\" THEN configure WebApplicationFactory to use in-memory DB and bypass health checks"
}

[2026-03-22 01:28] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "API health tests",
    "EXPECTATION": "API health endpoint tests should pass in CI without a real Postgres; the test host must bypass the Postgres health check and use in-memory services.",
    "NEW INSTRUCTION": "WHEN Api.Tests fail with 503 from /health THEN override health checks and use in-memory DB"
}

[2026-03-22 02:14] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "Makefile test target",
    "EXPECTATION": "Running 'make test' should execute existing test projects without MSBuild errors and not reference removed projects.",
    "NEW INSTRUCTION": "WHEN make test shows 'MSB1009: Project file does not exist' THEN update Makefile to only run existing test projects"
}

[2026-03-23 23:12] - Updated by Junie
{
    "TYPE": "correction",
    "CATEGORY": "Login submission no redirect",
    "EXPECTATION": "Logging in with valid credentials should authenticate and navigate away from the login page to the app dashboard/home.",
    "NEW INSTRUCTION": "WHEN login form submits but page stays on login THEN check network/auth response and console errors, fix redirect handling"
}

