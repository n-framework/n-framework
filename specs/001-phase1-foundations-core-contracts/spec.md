# Feature Specification: Phase 1 Foundations and Core Contracts

**Feature Branch**: `001-phase1-foundations-core-contracts`
**Spec Type**: Monorepo
**Project**: N/A
**Created**: 2026-03-16
**Status**: Draft
**Input**: User description: "Workspace creation and service scaffolding - The foundational capabilities that enable teams to create NFramework workspaces and generate standalone services with proper layer separation and core domain/application abstractions."

> **Note**: This spec is organized as monorepo. See `.specify/SPEC_ORGANIZATION.md` for details on spec organization types.

## User Scenarios & Testing _(mandatory)_

### User Story 1 - Create a workspace from a known template (Priority: P1)

As a platform engineer, I want to list available starter templates and create a new workspace from one of them so I can begin a new NFramework service environment without manual setup.

**Why this priority**: Initial is not usable unless a team can discover templates and create a workspace deterministically. This is the front door for all later service and framework work.

**Independent Test**: Can be fully tested by listing templates, creating a workspace in both interactive and non-interactive flows, and confirming the generated workspace includes the documented build and test entry points. This delivers immediate onboarding value even before additional framework features land.

**Acceptance Scenarios**:

1. **Given** the `nfw` CLI is available, **When** a user runs the template listing command, **Then** the user sees each available template with a stable identifier and short description.
2. **Given** an interactive terminal and more than one available template, **When** a user creates a workspace without specifying all required inputs, **Then** the user is prompted for the missing values, including template choice, and the selected workspace is created successfully.
3. **Given** a non-interactive environment, **When** a user creates a workspace with an explicit template identifier, **Then** the workspace is created without prompting for additional input.
4. **Given** a freshly created workspace, **When** the user opens its starter documentation, **Then** the user can find one documented build command and one documented test command for the generated workspace.

---

### User Story 2 - Scaffold a standalone service (Priority: P1)

As a service developer on the initial standalone path, I want to add a baseline service scaffold to a workspace so I can start from the intended layer structure instead of creating projects and folders by hand.

**Why this priority**: Workspace creation alone does not prove the product promise. Initial must already produce a standalone service shape that teams can build on immediately.

**Independent Test**: Can be fully tested by adding a new service to a fresh workspace and verifying the scaffold includes the required layers, a starter health or readiness endpoint, and succeeds with the documented build/test workflow without manual edits.

**Acceptance Scenarios**:

1. **Given** an existing Initial workspace, **When** a user adds a new standalone service, **Then** the generated service contains `Domain`, `Application`, `Infrastructure`, and `Api` layers in the standard structure.
2. **Given** a freshly generated service, **When** the user inspects the generated API baseline, **Then** the scaffold includes a starter health or readiness endpoint suitable for first-run verification.
3. **Given** a freshly generated service, **When** the user runs the documented build command, **Then** the workspace builds successfully without manual edits to generated files.
4. **Given** a freshly generated service, **When** the user runs the documented test command, **Then** the baseline tests complete successfully without requiring custom setup.

---

### User Story 3 - Build on shared core contracts (Priority: P2)

As a domain or application developer, I want standard core abstractions available from day one so I can model business behavior consistently without introducing infrastructure coupling.

**Why this priority**: Shared contracts are the architectural foundation for the service scaffold. They are essential to keeping later features consistent and preventing early drift.

**Independent Test**: Can be fully tested by referencing the shared domain and application packages from a generated service, creating simple domain and application examples, and confirming no infrastructure dependency is required for those examples to compile.

**Acceptance Scenarios**:

1. **Given** a generated service, **When** a developer models an entity, aggregate, value object, or domain event using the shared domain package, **Then** the model can be expressed without taking a dependency on infrastructure-specific components.
2. **Given** a generated service, **When** an application workflow returns a success or failure outcome, **Then** the workflow can use the shared application result model without relying on exceptions for normal business outcomes.
3. **Given** a reviewer inspects the generated dependency boundaries, **When** the reviewer checks the `Domain` and `Application` layers, **Then** neither layer depends on `Infrastructure` or `Api`.

---

### User Story 4 - Understand and preserve baseline boundaries (Priority: P2)

As a tech lead, I want Initial workspaces to make the intended layer responsibilities obvious so I can review changes against a clear architectural baseline before advanced automation exists.

**Why this priority**: Initial explicitly excludes the later architecture audit command, so the baseline still needs a clear and reviewable dependency model that teams can apply immediately.

**Independent Test**: Can be fully tested by reviewing the generated workspace structure, dependency rules, and quickstart guidance to confirm allowed and forbidden layer relationships are explicit and consistent across the scaffold.

**Acceptance Scenarios**:

1. **Given** a generated workspace, **When** a team reviews the architecture guidance, **Then** the allowed dependency direction between `Domain`, `Application`, `Infrastructure`, and `Api` is clearly stated.
2. **Given** a generated service, **When** the team inspects project references and starter code placement, **Then** the default scaffold already conforms to the documented boundary rules.
3. **Given** a new team member follows the quickstart, **When** they complete the setup flow, **Then** they can identify where to add domain logic, application logic, infrastructure integrations, and API endpoints without outside assistance.

### Edge Cases

- **No template identifier in non-interactive mode**: When a workspace is created outside an interactive terminal without an explicit template identifier and multiple templates are available, the command returns an actionable error listing valid template identifiers instead of blocking for input.
- **Missing required input with prompts disabled**: When a user runs workspace creation with `--no-input` and omits a required value such as the workspace name or template identifier, the command fails immediately with corrective guidance instead of prompting.
- **Unknown template identifier**: When a user requests a template that does not exist, the command fails without creating a partial workspace and explains how to list valid templates.
- **Existing target directory**: When the requested workspace name already exists or the destination is not empty, creation is refused unless the workflow explicitly supports safe reuse.
- **Duplicate service name**: When a user adds a service whose name already exists in the workspace, the command fails with a clear remediation path and does not overwrite the existing service.
- **Unsupported language selection**: When a user requests a service language outside Initial scope, the command explains that only the initial standalone service path is supported in this phase.
- **Interrupted generation**: When workspace or service creation is interrupted, the user is not left with an ambiguous partial result; the command either rolls back cleanly or explains the cleanup action required.
- **Boundary drift attempt**: When a developer tries to place infrastructure behavior in the `Domain` or `Application` layer, the generated structure and guidance make the violation visible before the change is treated as complete.
- **Fresh workspace validation**: When the documented build or test command is run immediately after workspace creation, the workflow succeeds even before additional business features are added.

## Requirements _(mandatory)_

### Functional Requirements

- **FR-001**: The system MUST provide a root Initial workflow that lets users discover templates, create a workspace, and scaffold a standalone service without manual project bootstrapping.
- **FR-002**: The template listing workflow MUST present each available starter template with a stable identifier and a concise description that supports deterministic selection.
- **FR-003**: Workspace creation MUST support interactive prompting for missing required input in real terminals and non-interactive execution through explicit arguments and options, including an opt-out switch for prompts.
- **FR-004**: A newly created workspace MUST include starter documentation that tells users which single command builds the workspace and which single command runs its test suite.
- **FR-005**: The service scaffolding workflow MUST create the standard four-layer structure consisting of `Domain`, `Application`, `Infrastructure`, and `Api`, plus a starter health or readiness endpoint for first-run verification.
- **FR-006**: Generated Initial services MUST compile and pass their baseline tests immediately after generation without requiring manual edits to generated assets.
- **FR-007**: The `Domain` and `Application` layers MUST remain free of infrastructure-specific dependencies in both generated structure and starter code.
- **FR-008**: The shared domain package MUST provide the baseline abstractions `Entity<TId>`, `AggregateRoot`, `ValueObject`, and `DomainEvent`.
- **FR-009**: The shared application package MUST provide `Result` and `Result<T>` as the baseline explicit outcome model for expected application flow results.
- **FR-010**: The shared application package MUST establish the Initial baseline contract set for later workflows by exposing `Result`, `Result<T>`, `ICommand<TResponse>`, and `IQuery<TResponse>` without requiring the advanced generator, routing, or dispatch features planned for later phases.
- **FR-011**: The generated workspace MUST document the intended responsibilities and allowed dependency direction for `Domain`, `Application`, `Infrastructure`, and `Api`.
- **FR-012**: Initial deliverables MUST preserve the product direction toward build-time setup and predictable startup by keeping workspace creation and service scaffolding template-driven and by avoiding runtime-only discovery in the generated baseline.
- **FR-013**: The root spec MUST treat detailed implementation behavior as project-level follow-up work in the relevant module repositories rather than duplicating those implementation specs in the monorepo spec.

### Key Entities

- **Template Catalog Entry**: A discoverable starter option with a stable identifier, human-readable description, and eligibility for interactive or non-interactive selection.
- **Workspace**: The generated root environment that contains starter documentation, common conventions, and the standard entry points for build and test.
- **Standalone Service Scaffold**: A generated service baseline that includes the four required layers, a starter health or readiness endpoint, and enough starter assets to compile and test immediately.
- **Layer Boundary Rule**: A documented rule that defines which layers may depend on which other layers and which dependencies are forbidden.
- **Core Domain Contract**: A reusable abstraction from the shared domain package that standardizes entity, aggregate, value object, and domain event modeling.
- **Core Application Contract**: A reusable abstraction from the shared application package that standardizes explicit result handling and future application workflow contracts.

## Success Criteria _(mandatory)_

### Measurable Outcomes

- **SC-001**: A first-time user can list templates, create a workspace, and scaffold one standalone service in 10 minutes or less by following the generated documentation only.
- **SC-002**: 100% of freshly generated Initial workspaces succeed with the documented build command on the first attempt without manual file edits.
- **SC-003**: 100% of freshly generated Initial workspaces succeed with the documented test command on the first attempt without manual environment customization.
- **SC-004**: 100% of generated standalone service scaffolds include the four required layers and publish the allowed dependency direction for those layers.
- **SC-005**: 100% of baseline domain and application examples in generated services can be authored without taking a dependency on infrastructure-specific packages.

## Assumptions

- Initial is limited to the first usable standalone service path and does not commit to distributed service orchestration.
- One or more official starter templates are sufficient for Initial as long as the catalog and selection workflow are deterministic.
- The monorepo spec coordinates behavior across multiple projects, while canonical implementation details continue to live in project-level specs within the relevant module repositories.
- The documented build and test commands operate at workspace level and are expected to validate a newly generated workspace without additional hand-written features.
- Initial may introduce baseline package and scaffold contracts that are later extended, but it does not need to ship the advanced automation planned for the following phase.

## Dependencies

- The existing CLI foundation spec at `src/nfw/specs/001-nfw-cli-skeleton/spec.md` remains a dependency for command surface expectations and root workflow integration.
- Project-level follow-up specs MUST be created or updated as the first implementation step in the affected module repositories for CLI workspace flows, service scaffolding, shared domain contracts, and shared application contracts.
- This monorepo must be able to consume and pin the relevant module changes once those project-level specs are implemented and merged.

## Clarifications

### Session 2026-03-16

- Q: Is this a single-project feature or a monorepo orchestrator feature? → A: It is a monorepo orchestrator feature because it coordinates the CLI, service scaffold, and shared core packages.
- Q: Does Initial require both interactive and non-interactive template selection? → A: Yes, both flows are required in Phase 1.
- Q: Are entity CRUD generation, standalone command/query generation, advanced automatic service wiring, distributed features, or polyglot support included here? → A: No, those remain out of scope for this phase.

## Non-Goals

- Generating entities, CRUD flows, standalone commands, or standalone queries.
- Delivering advanced automatic service wiring, automatic route generation, or the complete application execution pipeline.
- Shipping first-party adapters for persistence, validation, mapping, logging, localization, mailing, search, or other integration topics.
- Adding distributed development features such as local orchestration, Aspire defaults, Dapr adapters, or `nfw up`.
- Adding Go, Rust, shared contract sync, or other polyglot expansion work.
