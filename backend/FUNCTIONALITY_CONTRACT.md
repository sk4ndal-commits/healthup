### Template Functionality Contract

This document defines the baseline functionalities that this template provides and that any derivative templates or applications based on this factory must implement or maintain.

#### 1. Multi-Tenancy (Account Isolation)
- **Data Isolation**: All application data must be associated with an `Account` (Tenant).
- **Security**: Cross-tenant data access must be strictly prohibited at the database or service layer.
- **Context**: The system must be able to identify the current tenant context from the authenticated user.

#### 2. Authentication & Identity Management
- **Dual-Mode Auth**: Support for both Cookie-based (for Web/Razor Pages) and JWT-based (for API/Mobile) authentication.
- **Identity Flow**:
    - User Registration (with automatic Account creation or assignment).
    - Login / Logout.
    - Password Recovery (Forgot Password).
    - Token Refresh mechanism for API sessions.
- **Secure Storage**: Passwords must never be stored in plain text (use strong hashing).

#### 3. Authorization & Role-Based Access Control (RBAC)
- **Roles**: Support for at least two primary roles:
    - `Admin`: System-wide or Account-wide management.
    - `AppUser`: Standard application user.
- **Access Control**: Strict enforcement of role-based access to UI folders/pages and API endpoints.

#### 4. Localization (I18n)
- **Multi-language Support**: Infrastructure for translating UI text, validation messages, and system notifications.
- **Current Baseline**: Support for German (`de`) and English (`en`).
- **Dynamic Switching**: Ability for users to switch languages, with the preference persisted or detected via request.

#### 5. Audit Logging
- **Traceability**: Critical system actions (Create, Update, Delete, Login) must be logged.
- **Metadata**: Logs must include the Actor (User), Action, Entity Type, Entity ID, and a Timestamp.

#### 6. User Management (Administrative)
- **Admin Dashboard**: A protected area for administrators to:
    - List all users within their scope.
    - Create new users.
    - Reset user passwords.
    - Manage user activation status.

#### 7. API & Documentation
- **RESTful API**: Expose core functionalities via a documented API.
- **OpenAPI/Swagger**: Automatic generation of API documentation for discovery and testing.
- **Health Checks**: Endpoint to verify system pulse/readiness.

#### 8. Sample Reference Implementation (CRUD)
- **Baseline Feature**: A "Todo" or similar simple CRUD module that demonstrates:
    - Creating, reading, updating, and deleting resources.
    - Filtering by Tenant (Account).
    - Proper use of DTOs/ViewModels and Service layers.

#### 9. Developer Experience & Architecture
- **Layered Architecture**: Clear separation between Domain, Application, Infrastructure, and Presentation layers.
- **Dependency Injection**: Heavy use of DI for decoupled and testable code.
- **Seeding**: Initial data seeding for development and testing environments.
