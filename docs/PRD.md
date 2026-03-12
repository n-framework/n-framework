# Product Requirements Document (PRD): NFramework

## 1. Introduction / Overview

NFramework is a compile-time-first application framework and workspace standard for building clean architecture microservices. Its long-term product vision is a polyglot ecosystem across .NET, Go, and Rust, but the first delivery focus is a .NET 11 reference implementation that proves the core architecture, developer experience, Native AOT readiness, and cloud-native integrations.

The product exists to remove the runtime bloat, reflection-heavy startup cost, vendor lock-in, and inconsistent service structure commonly found in traditional enterprise frameworks. NFramework must give teams a fast and opinionated way to scaffold services, enforce architecture boundaries, generate boilerplate safely at compile time, and operate services in modern cloud environments from day one.

The product plan is structured around three constants:

- Beta scope is .NET-first and execution-focused.
- Product vision remains polyglot and contract-driven.
- Clean Architecture, Native AOT, Dapr, and CLI-driven automation are non-negotiable foundations.

## 2. Problem Statement

Teams building modern microservices repeatedly face the same issues:

- Frameworks depend heavily on runtime reflection, which increases startup time and reduces Native AOT compatibility.
- Clean Architecture rules are documented but not enforced, so boundaries decay over time.
- New services require large amounts of manual scaffolding and duplicate boilerplate.
- Infrastructure choices leak into application and domain layers, making services harder to test and replace.
- Polyglot teams struggle to keep the same architecture, naming, and contracts across languages.
- Cloud-native building blocks such as telemetry, messaging, state management, and local orchestration are often bolted on late instead of built in.

NFramework must solve these issues with a unified CLI, compile-time code generation, strict layer rules, and a clear path from local development to distributed deployment.

## 3. Goals

- Provide a single CLI-driven workflow for creating and evolving NFramework workspaces and services.
- Enforce Clean Architecture boundaries through project structure, package boundaries, and automated checks.
- Keep domain and application code free from infrastructure dependencies.
- Make generated .NET services fully trimmable and Native AOT compatible.
- Use compile-time code generation instead of runtime reflection for service registration, routing, and related framework mechanics.
- Make Dapr and Aspire first-class integrations for cloud-native development.
- Reduce time-to-first-service and time-to-first-CRUD endpoint to seconds, not hours.
- Establish a consistent folder structure and application model that can later extend to Go and Rust.
- Support contract-driven inter-service communication through gRPC and Protobuf in the polyglot expansion phase.

## 4. Target Users

- Enterprise architects who need enforceable architectural standards across multiple teams.
- Tech leads who want repeatable service templates and fewer framework decisions per project.
- Modern .NET teams who want to adopt .NET 11, source generators, and Native AOT without building their own platform.
- Platform engineers who need predictable scaffolding, local orchestration, and cloud-ready service defaults.
- Polyglot microservice teams who want one architectural standard across .NET, Go, and Rust.

## 5. Product Principles

1. **Compile-Time Magic Over Runtime Magic**  
   Framework behavior such as DI registration, route discovery, and supporting boilerplate should be generated at build time whenever practical.

2. **Pure Core**  
   Domain and application layers must not directly depend on EF Core, Dapr, RabbitMQ, HTTP frameworks, or other infrastructure libraries.

3. **Exception-Free Business Flow**  
   Application and domain workflows should prefer `Result<T>` or equivalent explicit outcome types over exceptions for expected business outcomes.

4. **Infrastructure as Replaceable Adapters**  
   Databases, caches, queues, and cloud integrations must be plugged in through abstractions so services can change infrastructure without rewriting core business logic.

5. **Cloud-Native by Default**  
   Telemetry, logging, metrics, local orchestration, and service-to-service communication should be part of the generated baseline, not optional afterthoughts.

6. **One Standard, Many Languages**  
   The workspace model, folder structure, naming conventions, and contract model should remain stable even when services are implemented in different languages.

## 6. Scope

### In Scope for Initial Beta

- `nfw` CLI with workspace creation, .NET service creation, entity generation, and architecture validation.
- `NFramework.Domain` and `NFramework.Application` packages for core abstractions.
- Source-generated DI registration and Minimal API route generation for .NET services.
- Wolverine-based request handling and messaging integration for .NET.
- EF Core and Dapper adapters for infrastructure access.
- Aspire AppHost and ServiceDefaults generation for local orchestration and observability.
- Dapr adapters for pub/sub, state management, and secret store.
- Single-command build and single-command test workflows for generated solutions.
- Documentation sufficient for a new team to create, run, and extend a sample service.

### Planned Expansion Scope

- Go service scaffolding with the same folder structure and architectural rules.
- Rust service scaffolding with the same folder structure and architectural rules.
- Protobuf-first contract generation and multi-language sync workflows.
- Polyglot local orchestration through the same CLI.
- Stronger cross-language SDK parity after the .NET reference path is proven.

## 7. User Stories

### US-001: Create a new workspace

**Description:** As a platform engineer, I want to create a new NFramework workspace with one command so that I can start a service ecosystem without manual setup.

**Acceptance Criteria:**

- [ ] `nfw new <workspace-name>` creates a workspace root with the expected folders, solution files, and baseline configuration.
- [ ] Generated workspace includes `.AppHost` and `.ServiceDefaults` when the workspace contains .NET services.
- [ ] The generated workspace can be built with one documented command.
- [ ] The generated workspace test suite can be run with one documented command.
- [ ] A CLI smoke test verifies the generated structure.

### US-002: Add a .NET service scaffold

**Description:** As a .NET developer, I want to generate a service scaffold so that I can start from a standard Clean Architecture baseline instead of creating projects by hand.

**Acceptance Criteria:**

- [ ] `nfw add service <name> --lang dotnet` creates `Domain`, `Application`, `Infrastructure`, and `Api` layers.
- [ ] Generated projects reference only allowed dependencies for their layer.
- [ ] The service compiles immediately after generation without manual file edits.
- [ ] The scaffold includes sample health or readiness endpoints.
- [ ] Automated smoke tests validate the generated service layout.

### US-003: Add an entity and CRUD flow

**Description:** As an application developer, I want to generate an entity and its CRUD flow so that I can deliver standard features without repeating boilerplate.

**Acceptance Criteria:**

- [ ] `nfw add entity Product --props Name:string,Price:decimal` generates entity, DTOs, commands, queries, handlers, repository contracts, and HTTP endpoints.
- [ ] Generated files are placed in the expected layer for each concern.
- [ ] Generated code builds without manual edits in a sample service.
- [ ] CLI validation rejects invalid property syntax with an actionable error message.
- [ ] Automated tests cover a generated sample CRUD flow.

### US-004: Check architecture boundaries

**Description:** As a tech lead, I want an automated architecture audit so that boundary violations are detected before they reach production.

**Acceptance Criteria:**

- [ ] `nfw check` scans a workspace for forbidden project references and forbidden namespace or package usage.
- [ ] The command exits with a non-zero status when a violation is found.
- [ ] The error output identifies the violating project, file, or dependency with a concrete remediation hint.
- [ ] The command can be executed in CI without requiring interactive input.
- [ ] Test fixtures prove detection of at least one valid and one invalid architecture case.

### US-005: Use shared domain abstractions

**Description:** As a domain developer, I want standard base abstractions so that aggregates and value objects are modeled consistently across services.

**Acceptance Criteria:**

- [ ] `NFramework.Domain` includes base abstractions for `Entity<TId>`, `AggregateRoot`, `ValueObject`, and `DomainEvent`.
- [ ] The abstractions do not depend on infrastructure packages.
- [ ] The package includes unit tests for equality, identity, and basic domain event behavior.
- [ ] Example generated services use the abstractions by default.

### US-006: Use explicit application results

**Description:** As an application developer, I want handlers and services to return explicit result objects so that business outcomes are predictable and AOT-friendly.

**Acceptance Criteria:**

- [ ] `NFramework.Application` includes `Result` and `Result<T>` or an equivalent explicit outcome model.
- [ ] Generated command and query handlers use the result model for expected business outcomes.
- [ ] Validation and business rule failures can be represented without throwing exceptions for normal flow.
- [ ] Unit tests cover success, validation failure, and business failure outcomes.

### US-007: Generate dependency injection registration

**Description:** As a .NET developer, I want DI registration generated at compile time so that the framework avoids runtime reflection and startup scanning.

**Acceptance Criteria:**

- [ ] Source generators emit deterministic registration code for supported services and handlers.
- [ ] Generated registration code is checked into build output and visible for debugging.
- [ ] No runtime assembly scanning is required for generated registrations.
- [ ] A generated sample service starts successfully using only the generated registration path.
- [ ] Build tests confirm the generator handles empty and non-empty service sets.

### US-008: Generate Minimal API routes

**Description:** As an API developer, I want HTTP routes generated from commands and queries so that endpoint wiring stays consistent and low-boilerplate.

**Acceptance Criteria:**

- [ ] Source generators discover supported commands and queries and emit Minimal API route mappings.
- [ ] Generated routes follow a documented naming and versioning convention.
- [ ] Controller-based APIs are not required for generated services.
- [ ] Route generation produces actionable diagnostics for unsupported patterns.
- [ ] Integration tests verify generated endpoints for a sample feature.

### US-009: Use Wolverine as the request and messaging adapter

**Description:** As a platform engineer, I want a high-performance request and messaging adapter so that services use one consistent application pipeline.

**Acceptance Criteria:**

- [ ] `NFramework.WolverineAdapter` integrates request handling with generated application services.
- [ ] The adapter is usable in a generated service without custom bootstrapping code.
- [ ] The adapter is compatible with the Result-based application flow.
- [ ] Integration tests cover at least one request/response path and one asynchronous message path.

### US-010: Use an EF Core infrastructure adapter

**Description:** As a backend developer, I want a first-party EF Core adapter so that I can persist aggregates without leaking EF-specific code into the core layers.

**Acceptance Criteria:**

- [ ] `NFramework.Infrastructure.EntityFramework` or equivalent package implements repository abstractions for supported scenarios.
- [ ] The adapter keeps EF-specific types out of domain and application projects.
- [ ] The generated sample uses an AOT-friendly EF Core setup where supported.
- [ ] Integration tests cover create, read, update, and delete operations through the abstraction.

### US-011: Use a Dapper infrastructure adapter

**Description:** As a backend developer, I want a first-party Dapper adapter so that services can choose lightweight data access without changing application code.

**Acceptance Criteria:**

- [ ] `NFramework.Infrastructure.Dapper` or equivalent package implements the same application-facing repository abstractions where applicable.
- [ ] The adapter can coexist with the EF Core adapter in the same workspace.
- [ ] A sample feature can be switched to the Dapper adapter without changing application layer logic.
- [ ] Integration tests cover basic query and command operations through the abstraction.

### US-012: Generate Aspire defaults

**Description:** As a platform engineer, I want generated services to include local orchestration and observability defaults so that teams start with production-minded foundations.

**Acceptance Criteria:**

- [ ] Generated workspaces include `.AppHost` and `.ServiceDefaults` projects for .NET services.
- [ ] Logging, metrics, and tracing are enabled by default in generated samples.
- [ ] A sample workspace can be started locally through the documented workflow.
- [ ] Smoke tests validate that generated orchestration configuration is present and wired correctly.

### US-013: Use Dapr adapters

**Description:** As a microservice developer, I want Dapr-backed abstractions for platform concerns so that infrastructure choices remain replaceable and cloud-neutral.

**Acceptance Criteria:**

- [ ] First-party adapters exist for Dapr pub/sub, state management, and secret store.
- [ ] Application and domain layers depend only on NFramework abstractions, not Dapr SDK types.
- [ ] Sample services demonstrate at least one state interaction and one asynchronous event flow.
- [ ] Integration tests validate adapter behavior against local development dependencies or suitable test doubles.

### US-014: Start a workspace locally

**Description:** As a developer, I want to boot a workspace and its supporting services with one command so that local setup is fast and predictable.

**Acceptance Criteria:**

- [ ] `nfw up` starts the supported local orchestration workflow for the workspace.
- [ ] The command starts required service processes and documented supporting dependencies for the generated sample.
- [ ] The command reports startup failures with actionable diagnostics.
- [ ] A smoke test proves a newly generated sample can be brought up with the documented workflow.

### US-015: Publish quickstart and architecture guidance

**Description:** As a new NFramework user, I want clear documentation so that I can create a service, understand the architecture rules, and avoid common mistakes.

**Acceptance Criteria:**

- [ ] Documentation includes a quickstart from workspace creation to a running sample.
- [ ] Documentation explains layer responsibilities and forbidden dependencies.
- [ ] Documentation explains the Result pattern and generated route model.
- [ ] Documentation includes troubleshooting guidance for the most common generator and local setup failures.

### US-016: Add a Go service scaffold

**Description:** As a platform engineer, I want to generate Go services with the same architectural structure so that polyglot teams can follow one standard.

**Acceptance Criteria:**

- [ ] `nfw add service <name> --lang go` generates the standard NFramework folder structure.
- [ ] Generated Go services expose the same layer boundaries and contract placement expected in .NET services.
- [ ] Generated service instructions document the runtime, build, and test commands.
- [ ] Smoke tests validate scaffold generation for the Go path.

### US-017: Add a Rust service scaffold

**Description:** As a platform engineer, I want to generate Rust services with the same architectural structure so that polyglot teams can follow one standard.

**Acceptance Criteria:**

- [ ] `nfw add service <name> --lang rust` generates the standard NFramework folder structure.
- [ ] Generated Rust services expose the same layer boundaries and contract placement expected in .NET services.
- [ ] Generated service instructions document the runtime, build, and test commands.
- [ ] Smoke tests validate scaffold generation for the Rust path.

### US-018: Sync Protobuf contracts across languages

**Description:** As a polyglot team, I want shared service contracts synchronized from one source so that inter-service communication stays type-safe and consistent.

**Acceptance Criteria:**

- [ ] `nfw sync` detects changes in supported `.proto` files and regenerates affected client and server code.
- [ ] Regenerated artifacts are produced for all supported target languages in the workspace.
- [ ] Sync failures identify the broken contract and the affected service clearly.
- [ ] Integration tests validate a sample gRPC contract shared by at least two languages.

## 8. Functional Requirements

- FR-1: The system must provide an `nfw` CLI as the primary entry point for workspace and service lifecycle operations.
- FR-2: `nfw new <workspace-name>` must create a valid NFramework workspace with baseline configuration, documentation, and buildable starter assets.
- FR-3: `nfw add service <name> --lang dotnet` must generate a .NET service with `Domain`, `Application`, `Infrastructure`, and `Api` layers.
- FR-4: The CLI must validate command arguments and return actionable errors for unsupported languages, invalid identifiers, and malformed property declarations.
- FR-5: `nfw add entity <name> --props ...` must generate entity, DTO, command, query, handler, repository abstraction, and endpoint boilerplate for .NET services.
- FR-6: Generated code must follow documented naming, folder, and namespace conventions.
- FR-7: Domain and application layers must remain free of infrastructure-specific dependencies.
- FR-8: The framework must provide reusable domain abstractions for entities, aggregate roots, value objects, and domain events.
- FR-9: The framework must provide explicit result types for application workflows and business-rule outcomes.
- FR-10: Runtime reflection must not be required for DI registration, route discovery, or other core framework mechanics in the .NET runtime path.
- FR-11: Source generators must generate DI registration code for supported handlers and services.
- FR-12: Source generators must generate Minimal API routes from supported commands and queries.
- FR-13: Generated HTTP APIs must use Minimal API conventions; controller-based scaffolding is out of scope.
- FR-14: The framework must provide a Wolverine-based adapter for request handling and asynchronous messaging in .NET services.
- FR-15: The framework must provide an EF Core adapter that preserves separation between infrastructure and core layers.
- FR-16: The framework must provide a Dapper adapter that preserves separation between infrastructure and core layers.
- FR-17: Generated .NET workspaces must include Aspire AppHost and ServiceDefaults projects with logging, metrics, and tracing defaults.
- FR-18: The framework must provide first-party Dapr adapters for pub/sub, state management, and secret store concerns.
- FR-19: `nfw check` must perform architecture validation and fail fast on boundary violations.
- FR-20: Generated samples must build with one documented command and run tests with one documented command.
- FR-21: Generated .NET samples must be trimmable and designed for Native AOT compatibility.
- FR-22: `nfw up` must start the supported local orchestration workflow for a generated workspace.
- FR-23: The product must define one standard workspace and layer structure that can be used across supported languages.
- FR-24: `nfw add service --lang go` and `nfw add service --lang rust` must generate services that conform to the shared workspace standard once polyglot support is released.
- FR-25: `nfw sync` must regenerate shared contract artifacts from Protobuf definitions for supported languages once contract sync is released.
- FR-26: The framework must support gRPC for synchronous inter-service contracts in the polyglot expansion phase.
- FR-27: The framework must support Dapr-backed pub/sub for asynchronous inter-service communication in the polyglot expansion phase.
- FR-28: Documentation must explain setup, architecture rules, generator usage, and troubleshooting for generated projects.

## 9. Non-Goals (Out of Scope)

- Supporting ASP.NET MVC or controller-based scaffolding in the initial product.
- Providing runtime reflection fallbacks for framework features that are expected to be compile-time generated.
- Supporting every database, queue, cache, or cloud provider in the first release.
- Replacing Dapr with provider-specific abstractions inside the domain or application layers.
- Shipping a graphical UI for project generation or orchestration.
- Generating arbitrary legacy project layouts outside the NFramework standard structure.
- Achieving full feature parity across .NET, Go, and Rust in the initial beta.
- Hiding all generated code from developers; generated code should remain inspectable and debuggable.
- Solving deployment platform setup for every hosting environment beyond the documented defaults.
- Supporting exception-driven business flow as a primary application pattern.

## 10. Design Considerations

- The CLI should feel instant, deterministic, and safe to rerun where commands are naturally idempotent.
- Generated code should be readable by humans and suitable for normal code review, not opaque machine output.
- Naming conventions should be consistent across commands, project folders, namespaces, and generated types.
- The standard layer structure should remain stable across languages even when framework implementations differ.
- Error messages should state what failed, why it failed, and what command or file the user should inspect next.
- Documentation examples should use real command lines and realistic service names rather than placeholder-only snippets.
- Default output should optimize for developer experience, but never at the cost of hidden architectural coupling.

## 11. Technical Considerations

- The initial runtime target is .NET 11, with C# 14/15 features used where they improve clarity, code generation, or AOT compatibility.
- The CLI implementation language is still a product decision between Go and Native AOT C#; both are acceptable if startup time remains near-instant.
- Source generators and analyzers will likely be required together: generators to create code, analyzers to enforce rules and emit diagnostics.
- Native AOT and trimming compatibility must be validated continuously in CI rather than assumed from design alone.
- Wolverine is the preferred .NET messaging and request-handling adapter because the product prioritizes AOT compatibility and performance.
- EF Core usage must stay within an AOT-friendly subset or documented compatibility envelope; unsupported patterns must fail clearly.
- Dapr and Aspire introduce local development dependencies that must be documented and automated through the generated workflow as much as possible.
- Cross-language contract sync will depend on a clear Protobuf ownership model and deterministic generated artifact locations.
- The repository should provide one-command build and one-command test workflows for generated samples to support reliable onboarding and CI.

## 12. Success Metrics

- A generated "hello world" .NET microservice builds with **0** Native AOT or trimming warnings.
- A generated standard .NET microservice cold-starts in **less than 50 ms** under the agreed benchmark conditions.
- Generating a standard CRUD flow from the CLI takes **less than 10 seconds** from command execution to a buildable endpoint.
- Creating a new workspace completes in **less than 3 seconds** on the agreed baseline developer machine.
- Cross-language gRPC overhead between two generated services is **less than 2 ms** once polyglot support is delivered.
- A .NET developer can understand the structure of a generated Go service in **10 minutes or less** using NFramework conventions and documentation.
- Generated starter solutions build and test successfully in CI without manual patch steps.

## 13. Release Phases

### Phase 1: Foundations and .NET-first CLI (March-April 2026)

- Deliver the initial `nfw` CLI skeleton.
- Deliver workspace creation and `.NET` service scaffolding.
- Deliver `NFramework.Domain` and `NFramework.Application`.
- Prove the Result pattern, core abstractions, and baseline architecture rules.

### Phase 2: Code Generation and Infrastructure (May-June 2026)

- Deliver entity-to-CRUD generation for .NET services.
- Deliver source-generated DI registration and Minimal API routing.
- Deliver Wolverine, EF Core, and Dapper adapters.
- Deliver `nfw check` for architecture validation.

### Phase 3: Cloud-Native Defaults and Beta (July 2026+)

- Deliver Aspire defaults and Dapr adapters.
- Deliver `nfw up` for local orchestration.
- Publish quickstart and architecture documentation.
- Release the first beta for the .NET-first platform path.

### Phase 4: Polyglot Expansion (Post-Beta)

- Deliver Go and Rust service scaffolds.
- Deliver `nfw sync` for Protobuf-driven contract generation.
- Stabilize shared polyglot patterns, contracts, and local orchestration.
- Expand SDK coverage while preserving the same architectural standard.

## 14. Open Questions

- Should the CLI be implemented in Go or Native AOT C# for the first public release?
- Is Dapr mandatory in all generated distributed solutions, or optional but first-class?
- Which database providers must be first-party supported in the initial beta?
- How much EF Core functionality can be supported while preserving the "0 AOT warning" goal?
- Should `nfw add entity` also generate migrations, test fixtures, and sample seed data, or stop at code scaffolding?
- What is the exact boundary between the beta promise and post-beta polyglot support for Go and Rust?
- Which benchmark environment defines the official startup-time and CLI-speed KPIs?
