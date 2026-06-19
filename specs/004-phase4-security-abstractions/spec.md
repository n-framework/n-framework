# Feature Specification: Phase 4 - Security Abstractions and Implementations

## Overview

This specification defines the security abstractions and first-party implementations for NFramework services. This phase delivers authentication, authorization, and encryption building blocks while maintaining clean architecture boundaries and keeping security concerns out of domain and application layers.

## User Scenarios & Testing

### User Story 1 - Secure Command and Query Operations (Priority: P1)

As a developer, I want to protect commands and queries with declarative authorization so that I can enforce access control without writing manual security checks in every handler.

**Why this priority**: Authorization is the most fundamental security concern. The Phase 2 mediator pipeline already has an Authorization behavior placeholder that needs concrete security types to function.

**Independent Test**: Can be fully tested by marking a command handler with a permission requirement and verifying that unauthorized requests are rejected before reaching the handler.

**Acceptance Scenarios**:

1. **Given** a command handler marked with `[RequiresPermission("products.create")]`, **When** an unauthorized user sends the command, **Then** the authorization pipeline behavior rejects it before handler execution
2. **Given** a query handler marked with `[RequiresRole("Admin")]`, **When** a user without the Admin role sends the query, **Then** a 403 response is returned
3. **Given** an unauthenticated request, **When** it reaches a secured endpoint, **Then** a 401 response is returned with appropriate authentication challenge headers

---

### User Story 2 - Authenticate Users with JWT (Priority: P1)

As a developer, I want framework-provided JWT authentication so that I can secure my API endpoints without implementing token validation from scratch.

**Why this priority**: JWT is the most common authentication mechanism for modern APIs. Without authentication, authorization behaviors cannot function.

**Independent Test**: Can be fully tested by configuring JWT authentication and verifying that valid tokens grant access while invalid or expired tokens are rejected.

**Acceptance Scenarios**:

1. **Given** JWT authentication is configured, **When** a request arrives with a valid JWT token, **Then** the user identity is extracted and made available to authorization behaviors
2. **Given** a request with an expired JWT token, **When** it reaches a secured endpoint, **Then** a 401 response is returned
3. **Given** JWT configuration, **When** the token signing key is rotated, **Then** tokens signed with the old key are rejected after a configurable grace period

---

### User Story 3 - Manage Secrets Securely (Priority: P2)

As a developer, I want framework-provided secret management abstractions so that connection strings, API keys, and encryption keys are never hardcoded in configuration files.

**Why this priority**: Secret management is critical for production security but development environments can function with local configuration initially.

**Independent Test**: Can be fully tested by configuring a secret provider and verifying that secrets are retrieved at runtime without appearing in configuration files or source code.

**Acceptance Scenarios**:

1. **Given** a secret management adapter is configured, **When** the application starts, **Then** secrets are retrieved from the configured provider (environment variables, key vault)
2. **Given** a secret is updated in the provider, **When** the application is restarted, **Then** the new secret value is used without code changes

---

### Edge Cases

- What happens when the authorization behavior encounters a handler without security attributes? → The handler is treated as publicly accessible (no authorization check)
- What happens when JWT token validation fails due to clock skew? → A configurable clock skew tolerance (default 5 minutes) is applied
- What happens when the secret provider is unavailable at startup? → The application fails fast with a descriptive error identifying the unreachable provider
- What happens when multiple authentication schemes are configured? → The framework supports scheme selection via attributes, defaulting to the primary scheme

## Requirements

### Functional Requirements

#### Security Abstractions

- **FR-001**: The system MUST provide `NFramework.Security.Abstractions` with interfaces for user identity, claims, permissions, and roles
- **FR-002**: The system MUST provide attribute-based authorization markers (`[RequiresPermission]`, `[RequiresRole]`)
- **FR-003**: The system MUST integrate authorization with the existing Authorization pipeline behavior from Phase 2
- **FR-004**: The system MUST keep security abstraction types out of the domain layer

#### Authentication

- **FR-005**: The system MUST provide a JWT authentication adapter with token generation and validation
- **FR-006**: The system MUST support configurable token expiration, signing algorithms, and issuer/audience validation
- **FR-007**: The system MUST provide an API key authentication adapter for service-to-service communication
- **FR-008**: The system MUST support multiple authentication schemes with per-endpoint scheme selection

#### Authorization

- **FR-009**: The system MUST provide authorization handlers for permission-based and role-based access control
- **FR-010**: The system MUST support policy-based authorization for complex access control rules
- **FR-011**: The system MUST propagate authorization failures through the Railway pattern as UnionError

#### Encryption and Secrets

- **FR-012**: The system MUST provide encryption adapters for data at rest (symmetric and asymmetric)
- **FR-013**: The system MUST provide secret management adapters for environment variables and key vault integration
- **FR-014**: The system MUST ensure encryption keys are never logged or exposed in error messages

### Key Entities

- **UserIdentity**: Represents an authenticated user with claims, permissions, and roles
- **Permission**: Named authorization requirement that can be checked against a user's granted permissions
- **AuthenticationToken**: JWT or API key credential with expiration, issuer, and signing metadata
- **SecretReference**: Named reference to a secret value stored in an external provider

## Success Criteria

### Measurable Outcomes

- **SC-001**: Developers can secure a command or query handler by adding a single authorization attribute
- **SC-002**: Authentication and authorization work without runtime reflection
- **SC-003**: Security adapters are replaceable without modifying domain or application code
- **SC-004**: Integration tests validate end-to-end authentication, authorization, and encryption workflows
- **SC-005**: Authorization failures are propagated through the Railway pattern (UnionError) consistently

## Assumptions

- Phase 2 Authorization pipeline behavior provides the integration point for security checks
- Phase 3 exception handling translates authorization failures to appropriate HTTP responses (401/403)
- JWT is the primary authentication mechanism; OAuth2/OIDC provider integration is out of scope for this phase
- API key authentication is designed for service-to-service communication, not end-user authentication
- Azure Key Vault is the first-party key vault adapter; other providers follow the same abstraction

## Dependencies

- **Phase 2**: CQRS abstractions and Authorization pipeline behavior must be stable
- **Phase 3**: Exception handling and Problem Details integration must be available for translating security failures to HTTP responses
- **Phase 3**: API routing generators must support secured endpoints

## Non-Goals

- Full OAuth2/OIDC provider integration (deferred to later phase)
- Multi-factor authentication (MFA)
- Session-based authentication (JWT and API key only)
- RBAC administration UI or API
- Certificate-based mutual TLS authentication
- CORS policy management (handled by Phase 3 WebAPI module)
