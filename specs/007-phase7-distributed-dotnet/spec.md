# Feature Specification: Phase 7 - Distributed .NET Expansion

## Overview

This specification defines the expansion from standalone .NET services into distributed local development, observability defaults, and Dapr-backed platform adapters. This phase fulfills the PRD promise that cloud-native defaults become part of the framework once the standalone path is proven.

## User Scenarios & Testing

### User Story 1 - Boot Distributed Workspace Locally (Priority: P1)

As a developer, I want to start a distributed .NET workspace with a single command so that I can develop and test multi-service interactions locally without manual infrastructure setup.

**Why this priority**: Local development experience for distributed services is the primary value proposition of this phase. Without a single-command startup, distributed development is too friction-heavy for adoption.

**Independent Test**: Can be fully tested by running `nfw up` in a workspace with multiple services and verifying all services start with working inter-service communication.

**Acceptance Scenarios**:

1. **Given** a workspace with two services, **When** I run `nfw up`, **Then** both services start with Aspire orchestration and can communicate
2. **Given** a distributed workspace, **When** a service fails to start, **Then** actionable diagnostics are displayed identifying the failure cause
3. **Given** `nfw up` is running, **When** I modify a service, **Then** the system supports hot-reload or restart of the modified service

---

### User Story 2 - Use Observability Defaults (Priority: P1)

As a developer, I want logging, metrics, and tracing enabled by default in distributed services so that I can debug cross-service issues without manual instrumentation setup.

**Why this priority**: Observability is essential for distributed system debugging. Without default instrumentation, developers spend significant time setting up basic monitoring before they can debug actual issues.

**Independent Test**: Can be fully tested by making a request that spans two services and verifying correlated logs, traces, and metrics appear in the Aspire dashboard.

**Acceptance Scenarios**:

1. **Given** a distributed workspace, **When** a request spans two services, **Then** correlated traces are visible in the Aspire dashboard
2. **Given** a distributed service, **When** it processes requests, **Then** structured logs include correlation IDs linking related operations
3. **Given** a distributed workspace, **When** I open the Aspire dashboard, **Then** service health, metrics, and trace data are displayed

---

### User Story 3 - Use Dapr for State and Messaging (Priority: P2)

As a developer, I want to use Dapr adapters for pub/sub and state management so that I can build distributed workflows without coupling my domain code to specific infrastructure.

**Why this priority**: Dapr provides portable abstractions for distributed building blocks, but services can function with direct infrastructure coupling initially.

**Independent Test**: Can be fully tested by publishing an event through the Dapr pub/sub adapter and verifying a subscriber service receives and processes it.

**Acceptance Scenarios**:

1. **Given** Dapr pub/sub is configured, **When** a service publishes a domain event, **Then** subscriber services receive the event through the Dapr adapter
2. **Given** Dapr state management is configured, **When** a service stores state, **Then** the state is persisted through the Dapr state store adapter
3. **Given** a service using Dapr adapters, **When** I inspect domain and application layers, **Then** no Dapr-specific types are referenced

---

### Edge Cases

- What happens when Dapr sidecar is not running? → The service starts but Dapr-dependent operations fail with descriptive errors identifying the missing sidecar
- What happens when Aspire is not installed? → `nfw up` detects the missing dependency and provides installation instructions
- What happens when distributed services have different .NET versions? → The workspace validates SDK version compatibility at startup

## Requirements

### Functional Requirements

#### Aspire Integration

- **FR-001**: The system MUST generate `.AppHost` and `.ServiceDefaults` projects for distributed workspaces
- **FR-002**: The system MUST enable logging, metrics, and tracing by default in generated ServiceDefaults
- **FR-003**: The system MUST support `nfw up` for local orchestration with Aspire

#### Dapr Adapters

- **FR-004**: The system MUST provide first-party Dapr adapters for pub/sub messaging
- **FR-005**: The system MUST provide first-party Dapr adapters for state management
- **FR-006**: The system MUST provide first-party Dapr adapters for secret store
- **FR-007**: The system MUST keep Dapr-specific types out of domain and application layers

#### Developer Experience

- **FR-008**: `nfw up` MUST provide actionable startup diagnostics when services fail to start
- **FR-009**: The system MUST provide sample services demonstrating asynchronous event flow and state interaction
- **FR-010**: The system MUST provide smoke tests for distributed startup and adapter wiring
- **FR-011**: The system MUST provide documentation for distributed .NET service development

### Key Entities

- **AppHost**: Aspire application host project that orchestrates multi-service startup and configuration
- **ServiceDefaults**: Shared project containing default observability, health check, and resilience configuration
- **DaprAdapter**: Framework adapter wrapping a Dapr building block (pub/sub, state, secrets) behind NFramework abstractions

## Success Criteria

### Measurable Outcomes

- **SC-001**: Developers can boot a distributed .NET workspace with a single documented command (`nfw up`)
- **SC-002**: Distributed concerns (pub/sub, state, secrets) stay behind NFramework abstractions and adapters with zero Dapr leakage into domain or application layers
- **SC-003**: Generated distributed samples expose logging, metrics, and tracing defaults visible in the Aspire dashboard
- **SC-004**: Distributed startup failures surface actionable diagnostics within 5 seconds of the failure

## Assumptions

- Standalone .NET beta (Phases 1-6) is stable before distributed features expand the support matrix
- .NET Aspire is the orchestration mechanism for local distributed development
- Dapr sidecar model is the adapter mechanism for distributed building blocks
- Distributed features are opt-in at the workspace and template level (standalone services are unaffected)

## Dependencies

- **Phases 1-6**: Standalone .NET beta must be stable
- **Aspire SDK**: .NET Aspire must be available for .NET 11
- **Dapr**: Dapr sidecar must be available for local development
- **Phase 3**: Logging and cross-cutting concern abstractions must be mature enough to integrate with distributed observability

## Non-Goals

- Production Kubernetes deployment automation
- Multi-cloud infrastructure provisioning
- Service mesh configuration (Istio, Linkerd)
- Container image building or registry management
- CI/CD pipeline generation for distributed deployments
