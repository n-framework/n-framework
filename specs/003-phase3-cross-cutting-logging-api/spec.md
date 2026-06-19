# Feature Specification: Phase 3 - Cross-Cutting Concerns, Logging, and API Routing

## Overview

This specification defines the cross-cutting concern abstractions, logging infrastructure, and API routing source generators required to make NFramework a complete application platform. Items deferred from Phase 2 (logging abstractions, OpenAPI/Swagger, mapping, caching adapters, exception handling) are consolidated here alongside new API routing automation.

This phase bridges the gap between the compile-time application model (Phase 2) and production-ready services by delivering the essential building blocks most real services require while preserving clean architecture boundaries.

## User Scenarios & Testing

### User Story 1 - Use Logging in Generated Services (Priority: P1)

As a .NET developer, I want framework-provided logging abstractions so that my services have structured logging without coupling domain or application code to a specific logging library.

**Why this priority**: Logging is the most universally required cross-cutting concern. Every production service needs logging, and the current `NFramework.Logging.Abstractions` package is an empty stub.

**Independent Test**: Can be fully tested by adding logging to a generated service handler and verifying log output appears without importing any infrastructure-specific logging library in the application layer.

**Acceptance Scenarios**:

1. **Given** a generated service with NFramework logging, **When** a command handler executes, **Then** structured log entries are emitted through the framework logging abstraction
2. **Given** a service using `NFramework.Logging.Abstractions`, **When** I inspect the application layer imports, **Then** no infrastructure-specific logging library (Serilog, NLog, etc.) is referenced
3. **Given** a service with logging configured, **When** I switch the logging adapter from Serilog to Microsoft.Extensions.Logging, **Then** application and domain code requires zero changes

---

### User Story 2 - Map Between Domain and API Models (Priority: P1)

As a developer, I want framework-provided mapping abstractions so that I can transform between domain entities, DTOs, and API models without coupling layers to a specific mapping library.

**Why this priority**: Mapping is required by every CRUD workflow generated in Phase 2. Currently, generated handlers must implement manual mapping or depend directly on a mapping library.

**Independent Test**: Can be fully tested by generating a CRUD flow and verifying domain-to-DTO mapping works through the framework abstraction without importing Mapster or AutoMapper in the application layer.

**Acceptance Scenarios**:

1. **Given** a generated CRUD handler, **When** it maps an entity to a DTO, **Then** the mapping uses the framework abstraction rather than a direct library reference
2. **Given** a mapping adapter is configured, **When** I switch from Mapster to AutoMapper, **Then** domain and application code requires zero changes

---

### User Story 3 - Cache Query Results (Priority: P2)

As a developer, I want framework-provided caching abstractions so that I can cache frequently accessed data without coupling application logic to a specific caching implementation.

**Why this priority**: Caching pipeline behaviors already exist in the mediator pipeline (Phase 2) but lack framework-level abstraction contracts for the actual cache storage.

**Independent Test**: Can be fully tested by enabling the caching pipeline behavior on a query handler and verifying results are cached and retrieved through the framework abstraction.

**Acceptance Scenarios**:

1. **Given** a query handler with caching enabled, **When** the same query executes twice, **Then** the second execution retrieves the result from cache
2. **Given** a caching adapter is configured, **When** I switch from IMemoryCache to IDistributedCache, **Then** application code requires zero changes
3. **Given** a command that invalidates cache, **When** the CacheRemoving behavior executes, **Then** the relevant cached entries are removed through the framework abstraction

---

### User Story 4 - Generate API Routes from Handlers (Priority: P2)

As a developer, I want source-generated Minimal API route mappings so that new endpoints are automatically wired from my command and query handlers without manual route registration.

**Why this priority**: Phase 2 generates endpoint boilerplate via Tera templates, but source-generated route discovery would eliminate manual wiring entirely and keep routes in sync with handlers automatically.

**Independent Test**: Can be fully tested by adding a new command handler and verifying the corresponding API route is automatically registered without manual MapPost/MapGet calls.

**Acceptance Scenarios**:

1. **Given** a command handler exists, **When** the project compiles, **Then** a corresponding Minimal API route is registered via source generation
2. **Given** a generated route, **When** I inspect the OpenAPI documentation, **Then** the endpoint appears with correct HTTP method, path, and request/response types
3. **Given** a secured command handler, **When** the route is generated, **Then** authorization attributes are applied to the endpoint

---

### User Story 5 - Handle Exceptions Consistently (Priority: P2)

As a developer, I want framework-provided exception handling and Problem Details integration so that all services return consistent error responses without per-service error handling boilerplate.

**Why this priority**: Consistent error responses are important for API consumers but services can function with ad-hoc error handling patterns initially.

**Independent Test**: Can be fully tested by triggering an unhandled exception in a handler and verifying the response conforms to RFC 9457 Problem Details format.

**Acceptance Scenarios**:

1. **Given** an unhandled exception in a handler, **When** the exception reaches the HTTP pipeline, **Then** a Problem Details response is returned with appropriate status code and error details
2. **Given** a validation failure, **When** the validation pipeline behavior returns errors, **Then** a 400 Problem Details response with field-level error details is returned
3. **Given** a Railway error (UnionError), **When** the error propagates to the API layer, **Then** it is translated to the appropriate Problem Details response

---

### Edge Cases

- What happens when a logging adapter is not configured? → The framework falls back to a no-op logger that silently discards log entries
- What happens when a mapping type has no registered mapping configuration? → A descriptive error is thrown at startup during DI validation, not at runtime during a request
- What happens when cache storage is unavailable? → The caching behavior degrades gracefully by executing the handler directly without caching
- What happens when a handler has no corresponding route attribute? → The handler is excluded from route generation with a diagnostic warning
- What happens when OpenAPI generation encounters a type without serialization support? → A compile-time diagnostic is emitted identifying the problematic type

## Requirements

### Functional Requirements

#### Logging

- **FR-001**: The system MUST provide `NFramework.Logging.Abstractions` with logging interfaces that are independent of any specific logging library
- **FR-002**: The system MUST provide at least one logging adapter (Serilog or Microsoft.Extensions.Logging)
- **FR-003**: The system MUST support structured logging with contextual data (correlation IDs, request metadata)
- **FR-004**: The system MUST integrate logging with the existing Performance and Logging pipeline behaviors from Phase 2

#### Mapping

- **FR-005**: The system MUST provide mapping abstractions for object-to-object transformation
- **FR-006**: The system MUST provide at least one mapping adapter (Mapster)
- **FR-007**: The system MUST keep mapping abstractions in the application layer without referencing infrastructure-specific mapping libraries

#### Caching

- **FR-008**: The system MUST provide caching abstractions that support both in-memory and distributed cache backends
- **FR-009**: The system MUST provide adapters for IMemoryCache and IDistributedCache
- **FR-010**: The system MUST integrate caching abstractions with the existing Caching and CacheRemoving pipeline behaviors from Phase 2

#### Exception Handling

- **FR-011**: The system MUST provide exception handling middleware that produces RFC 9457 Problem Details responses
- **FR-012**: The system MUST translate Railway errors (UnionError) to appropriate HTTP status codes
- **FR-013**: The system MUST translate validation failures to 400 responses with field-level error details

#### API Route Generation

- **FR-014**: The system MUST provide source-generated Minimal API route mapping using incremental Roslyn generators
- **FR-015**: The system MUST discover command and query handlers and generate corresponding route registrations
- **FR-016**: The system MUST support attribute-based or convention-based route configuration
- **FR-017**: The system MUST generate OpenAPI/Swagger documentation annotations for generated endpoints
- **FR-018**: The system MUST support secured endpoints with authorization attributes in generated routes

#### Cross-Cutting Package Structure

- **FR-019**: The system MUST organize cross-cutting concerns under `NFramework.CrossCuttingConcerns.Abstractions` and technology-specific adapter packages
- **FR-020**: The system MUST ensure all cross-cutting concern abstractions are independent of infrastructure implementations

### Key Entities

- **LogEntry**: Structured log record with severity, message template, contextual properties, and correlation metadata
- **MappingProfile**: Configuration defining transformation rules between source and destination types
- **CacheEntry**: Cached data item with key, value, expiration policy, and invalidation tags
- **ProblemDetails**: RFC 9457 error response containing type, title, status, detail, and extension members
- **RouteDefinition**: Source-generated API route binding a handler to an HTTP method, path, and middleware chain

## Success Criteria

### Measurable Outcomes

- **SC-001**: Developers can add logging to a service without importing any infrastructure-specific logging library in domain or application layers
- **SC-002**: Switching between logging, mapping, or caching adapters requires zero changes to domain and application code
- **SC-003**: Generated API routes are registered automatically at compile time without manual wiring code
- **SC-004**: All exception responses conform to RFC 9457 Problem Details format
- **SC-005**: Generated services with cross-cutting concerns enabled remain trimmable and AOT-compatible with zero warnings
- **SC-006**: Integration tests validate logging, mapping, caching, exception handling, and API routing workflows end-to-end

## Assumptions

- Phase 2 CQRS abstractions, pipeline behaviors, and Tera template generation remain stable
- The existing 8 pipeline behaviors (Validation, Authorization, Caching, CacheRemoving, Logging, Performance, Transaction, Railway Validation) provide the integration points for cross-cutting concerns
- Mapster is the preferred first-party mapping adapter due to its compile-time code generation capabilities
- Serilog is the preferred first-party logging adapter due to its structured logging capabilities and .NET ecosystem adoption
- OpenAPI generation targets Swagger/Swashbuckle or the newer Microsoft.AspNetCore.OpenApi package based on .NET 11 availability
- Exception handling follows the RFC 9457 Problem Details standard for HTTP API error responses

## Dependencies

- **Phase 2**: CQRS abstractions, pipeline behaviors, and DI registration must remain stable
- **Phase 2**: Tera template generation and `nfw gen` commands must be stable for generated endpoint integration
- **Persistence**: `NFramework.Persistence.Abstractions` and `NFramework.Persistence.EFCore` must be stable before additional adapters are attempted
- **PRD Section 11**: First-class beta abstractions and first-party adapter priorities

## Non-Goals

- Supporting every logging, mapping, or caching library in the ecosystem (first-party adapters only)
- Auto-generating client SDKs from OpenAPI specifications
- Providing distributed tracing or metrics (deferred to Phase 7)
- Implementing API versioning or rate limiting
- Supporting GraphQL or gRPC endpoints (Minimal API only)

## Downstream Specifications Required

1. **NFramework.Logging.Abstractions** (`src/core-logging-dotnet/specs/`): Logging interfaces, structured logging contracts, adapter base classes
2. **NFramework.CrossCuttingConcerns.Abstractions** (`src/core-crosscutting-dotnet/specs/`): Mapping, caching, and exception handling abstractions
3. **NFramework.Analyzers.RouteGenerator** (`src/core-mediator-dotnet/specs/` or separate package): Roslyn incremental generator for Minimal API route discovery
4. **nfw-generators templates** (`src/nfw-generators/specs/`): Tera templates for cross-cutting concern boilerplate and configuration
