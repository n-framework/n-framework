# Product Requirements Document (PRD): NFramework

## 1. Introduction / Overview

NFramework is a compile-time-first application framework and workspace standard for building clean architecture services. Its long-term product vision is a polyglot ecosystem across .NET, Go, and Rust, but the first delivery focus is a .NET 11 reference implementation that proves the core architecture, developer experience, and Native AOT readiness.

The product exists to remove the runtime bloat, reflection-heavy startup cost, vendor lock-in, and inconsistent service structure commonly found in traditional enterprise frameworks. NFramework must give teams a fast and opinionated way to scaffold services, enforce architecture boundaries, generate boilerplate safely at compile time, and operate services in modern cloud environments from day one.

The product plan is structured around three constants:

- Beta scope is .NET-first and execution-focused.
- Product vision remains polyglot and contract-driven.
- Clean Architecture, Native AOT, and CLI-driven automation are non-negotiable foundations.

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
- Provide a coherent `.NET` service framework built on NFramework abstractions, generators, and adapters.
- Enforce Clean Architecture boundaries through project structure, package boundaries, and automated checks.
- Keep domain and application code free from infrastructure dependencies.
- Make generated .NET services fully trimmable and Native AOT compatible.
- Use compile-time code generation instead of runtime reflection for service registration, routing, and related framework mechanics.
- Reduce time-to-first-service and time-to-first-CRUD endpoint to seconds, not hours.
- Preserve high-value framework workflows such as template-based project creation, command/query generation, repository-driven CRUD scaffolding, and common cross-cutting feature toggles.
- Support the required `.NET` service topic areas of persistence, security, validation, mapping, logging, exception handling, localization, notification, and search through first-party abstractions plus adapters.
- Establish a consistent folder structure and application model that can later extend to Go and Rust.
- Make Dapr and Aspire first-class integrations for cloud-native development after the standalone .NET path is proven.
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
   Domain and application layers must not directly depend on persistence libraries, Dapr, RabbitMQ, HTTP frameworks, or other infrastructure libraries.

3. **Exception-Free Business Flow**  
   Application and domain workflows should prefer `Result<T>` or equivalent explicit outcome types over exceptions for expected business outcomes.

4. **Infrastructure as Replaceable Adapters**  
   NFramework must define abstractions per topic, and the codebase must depend on those abstractions. Databases, caches, queues, cloud integrations, and other popular libraries must be connected through adapters so services can change implementations without rewriting core business logic.

5. **Cloud-Native by Default**  
   Telemetry, logging, metrics, local orchestration, and service-to-service communication should be part of the generated baseline, not optional afterthoughts.

6. **One Standard, Many Languages**  
   The workspace model, folder structure, naming conventions, and contract model should remain stable even when services are implemented in different languages.

## 6. Scope

### In Scope for Initial Beta

- `nfw` CLI with template listing, workspace creation, .NET service creation, entity generation, command generation, query generation, and architecture validation.
- `NFramework.Domain`, `NFramework.Application`, and topic packages required for the standalone .NET service path.
- Source-generated DI registration and Minimal API route generation for .NET services.
- Framework-native CQRS execution with commands, queries, events, stream requests, and behaviors for .NET.
- Topic-specific abstractions used across the codebase, with infrastructure adapters for popular libraries and providers.
- Topic packages and adapters for persistence, security, validation, mapping, logging, exception handling, localization, translation, mailing, SMS, and search.
- Single-command build and single-command test workflows for generated solutions.
- Documentation sufficient for a new team to create, run, and extend a .NET service.

### Planned Post-Beta Scope

- Additional `.NET` integration packs that extend the standalone service path.
- Aspire AppHost and ServiceDefaults generation for distributed local development and observability.
- Dapr adapters for pub/sub, state management, and secret store.
- Local orchestration for distributed .NET service development.
- Go service scaffolding with the same folder structure and architectural rules.
- Rust service scaffolding with the same folder structure and architectural rules.
- Protobuf-first contract generation and multi-language sync workflows.
- Polyglot local orchestration through the same CLI.
- Stronger cross-language SDK parity after the .NET reference path is proven.

## 7. User Stories

### US-001: Create a new workspace

**Description:** As a platform engineer, I want to create a new NFramework workspace with one command so that I can start a service ecosystem without manual setup.

**Acceptance Criteria:**

- [ ] `nfw templates` lists available starter templates with identifiers and descriptions.
- [ ] `nfw new <workspace-name>` creates a workspace root with the expected folders, solution files, and baseline configuration.
- [ ] `nfw new <workspace-name> --template <id>` selects a starter template without requiring interactive input.
- [ ] The generated workspace can be built with one documented command.
- [ ] The generated workspace test suite can be run with one documented command.
- [ ] A CLI smoke test verifies the generated structure and template selection workflow.

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

### US-009: Provide a framework-native CQRS pipeline

**Description:** As a platform engineer, I want NFramework to provide its own CQRS execution pipeline so that services use one consistent application model built on framework abstractions.

**Acceptance Criteria:**

- [ ] NFramework provides built-in command and query dispatch abstractions that integrate with generated application services.
- [ ] The CQRS pipeline is usable in a generated service through NFramework abstractions and conventions.
- [ ] The CQRS pipeline is compatible with the Result-based application flow.
- [ ] Integration tests cover at least one command path, one query path, and one asynchronous message path.

### US-010: Define topic-specific abstractions

**Description:** As a framework developer, I want NFramework to define abstractions per topic so that the codebase depends on stable framework contracts instead of implementation-specific APIs.

**Acceptance Criteria:**

- [ ] NFramework defines clear abstractions for major topics such as CQRS execution, persistence, messaging, and platform integration where framework-level decoupling is required.
- [ ] Generated and hand-written application code depends on NFramework abstractions rather than implementation-specific APIs.
- [ ] Topic abstractions are named, scoped, and organized consistently with the framework's layer rules.
- [ ] Tests verify at least one framework workflow operating through topic abstractions rather than concrete implementations.

### US-011: Support adapter-based library integrations

**Description:** As a platform engineer, I want popular libraries to be supported through adapters so that teams can adopt familiar tooling without coupling the framework core to those libraries.

**Acceptance Criteria:**

- [ ] Infrastructure projects can implement NFramework topic abstractions using different popular libraries or providers.
- [ ] Swapping one adapter for another does not require changes in domain or application code.
- [ ] Library-specific types remain isolated to adapters and infrastructure projects.
- [ ] Integration tests verify at least one adapter implementation against a shared NFramework abstraction.

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

### US-019: Generate standalone commands and queries

**Description:** As an application developer, I want to generate standalone commands and queries so that I can add feature behavior without creating full CRUD scaffolding.

**Acceptance Criteria:**

- [ ] `nfw add command ApproveOrder Orders` generates the command, response, handler, and supporting route wiring when API exposure is enabled.
- [ ] `nfw add query GetOrderByNumber Orders` generates the query, response, handler, and supporting route wiring when API exposure is enabled.
- [ ] The generator can create a missing feature folder when the requested feature does not already exist.
- [ ] Command and query generation supports optional caching, logging, transaction, secured-operation, and API exposure settings.
- [ ] Build tests cover one generated command flow and one generated query flow.

### US-020: Use application workflow contracts

**Description:** As a framework consumer, I want reusable application workflow contracts so that common concerns are expressed consistently in handlers and services.

**Acceptance Criteria:**

- [ ] `NFramework.Application` exposes contracts for commands, queries, events, stream requests, and pipeline behaviors.
- [ ] `NFramework.Application` exposes contracts for business rules, pageable requests, and opt-in workflow markers such as caching, logging, transaction, and security.
- [ ] Generated handlers can implement the contracts without referencing infrastructure-specific packages.
- [ ] Tests cover command, query, stream, event, and at least one behavior chain.

### US-021: Use abstract repository-based persistence

**Description:** As an application developer, I want an abstraction-first persistence layer so that application code stays independent from specific data access libraries.

**Acceptance Criteria:**

- [ ] NFramework defines abstract repository contracts with CRUD, paging, dynamic querying, bulk operation, and migration application capabilities.
- [ ] Generated services depend on repository abstractions rather than concrete persistence libraries.
- [ ] At least one adapter implements the persistence abstractions on top of a popular `.NET` data access library.
- [ ] Tests cover pagination, dynamic filters, bulk operations, and migration application against the abstraction layer.

### US-022: Use security and authorization capabilities

**Description:** As a platform engineer, I want consistent security capabilities so that generated services can support authentication and authorization without ad hoc design.

**Acceptance Criteria:**

- [ ] NFramework exposes abstractions for JWT authentication, refresh tokens, authorization checks, operation claims, and authenticators.
- [ ] The `.NET` service path supports authenticator workflows for email, SMS, and OTP through abstractions and adapters.
- [ ] Generated services can mark operations as secured and receive consistent API security wiring.
- [ ] Tests cover login, token refresh, permission evaluation, and authenticator verification.

### US-023: Use cross-cutting service abstractions and adapters

**Description:** As a framework consumer, I want reusable cross-cutting abstractions and adapters so that common service capabilities are standardized without hard-coding specific libraries into the core.

**Acceptance Criteria:**

- [ ] NFramework provides abstractions plus initial adapters for validation, mapping, logging, problem details, localization, translation, mailing, SMS, and search.
- [ ] Library-specific types remain isolated to adapters and infrastructure projects.
- [ ] Tests exist for at least one adapter in each supported topic area.
- [ ] Generated documentation explains how each abstraction is intended to be used.

### US-024: Publish feature-complete .NET service guidance

**Description:** As a new team adopting NFramework, I want feature-complete documentation so that I can use the framework without reverse-engineering generator output.

**Acceptance Criteria:**

- [ ] Documentation explains template selection, service creation, entity generation, command generation, and query generation.
- [ ] Documentation explains the supported topic packages and abstraction-plus-adapter model.
- [ ] Documentation explains generated structure, supported conventions, and extension points.
- [ ] Documentation includes troubleshooting guidance for common generation, configuration, and adapter issues.

## 8. Functional Requirements

- FR-1: The system must provide an `nfw` CLI as the primary entry point for workspace and service lifecycle operations.
- FR-2: `nfw templates` must list available starter templates with stable identifiers and descriptions.
- FR-3: `nfw new <workspace-name> [--template <id>]` must create a valid NFramework workspace with baseline configuration, documentation, and buildable starter assets.
- FR-4: `nfw add service <name> --lang dotnet` must generate a `.NET` service with `Domain`, `Application`, `Infrastructure`, and `Api` layers.
- FR-5: The CLI must support both interactive and non-interactive workflows for the core generation commands.
- FR-6: The CLI must validate command arguments and return actionable errors for unsupported languages, invalid identifiers, malformed property declarations, and invalid option combinations.
- FR-7: `nfw add entity <name> --props ...` must generate entity, DTO, command, query, handler, repository contract, and endpoint boilerplate for `.NET` services.
- FR-8: `nfw add command <name> <feature>` must generate standalone command flow boilerplate for `.NET` services.
- FR-9: `nfw add query <name> <feature>` must generate standalone query flow boilerplate for `.NET` services.
- FR-10: Entity, command, and query generation must support optional feature settings for caching, logging, transaction, secured operation, and API exposure where applicable.
- FR-11: Generated code must follow documented naming, folder, and namespace conventions.
- FR-12: Domain and application layers must remain free of infrastructure-specific dependencies.
- FR-13: The framework must provide reusable domain abstractions for entities, aggregate roots, value objects, and domain events.
- FR-14: The framework must provide explicit result types for application workflows and business-rule outcomes.
- FR-15: The framework must provide application contracts for business rules, pageable requests, and opt-in workflow markers or options.
- FR-16: The framework must provide a built-in CQRS execution pipeline with commands, queries, events, stream requests, and pipeline behaviors in `.NET` services.
- FR-17: Runtime reflection must not be required for DI registration, route discovery, or other core framework mechanics in the `.NET` runtime path.
- FR-18: Source generators must generate DI registration code for supported handlers and services.
- FR-19: Source generators must generate Minimal API routes from supported commands and queries.
- FR-20: Generated HTTP APIs must use Minimal API conventions; controller-based scaffolding is out of scope.
- FR-21: The framework must provide topic-specific abstractions for workflows that should remain independent from implementation-specific libraries.
- FR-22: The framework must ensure library and provider integrations remain replaceable behind adapters without leaking technology-specific types into core layers.
- FR-23: The framework must provide abstract repository contracts with CRUD, paging, dynamic querying, bulk operations, migration application hooks, and documented concurrency expectations.
- FR-24: The `.NET` service path must include at least one persistence adapter that implements the repository abstractions on top of a popular data access library.
- FR-25: The framework must provide security abstractions for authentication, refresh tokens, authorization, operation claims, and authenticator workflows.
- FR-26: The `.NET` service path must support JWT authentication, refresh token workflows, authorization checks, and authenticator flows for email, SMS, and OTP through abstractions and adapters.
- FR-27: Generated or framework-provided API integrations must support secured operations and Swagger or OpenAPI security wiring for the `.NET` service path.
- FR-28: The framework must provide validation abstractions and at least one adapter for a popular validation library.
- FR-29: The framework must provide mapping abstractions and at least one adapter for a popular object mapper.
- FR-30: The framework must provide logging abstractions and at least one adapter for a popular structured logging library.
- FR-31: The `.NET` HTTP stack must provide exception handling and Problem Details style responses through framework-provided middleware or equivalent integration.
- FR-32: The framework must provide localization abstractions, request-locale integration for HTTP services, and adapters for resource-based and translation-based localization workflows.
- FR-33: The framework must provide mail and SMS abstractions plus adapter points for provider implementations.
- FR-34: The framework must provide search abstractions plus at least one adapter for a popular search engine.
- FR-35: `nfw check` must perform architecture validation and fail fast on boundary violations.
- FR-36: Generated samples must build with one documented command and run tests with one documented command.
- FR-37: Generated `.NET` samples must be trimmable and designed for Native AOT compatibility.
- FR-38: Generated `.NET` workspaces must include Aspire AppHost and ServiceDefaults projects with logging, metrics, and tracing defaults once distributed `.NET` support is released.
- FR-39: The framework must provide first-party Dapr adapters for pub/sub, state management, and secret store concerns once distributed `.NET` support is released.
- FR-40: `nfw up` must start the supported local orchestration workflow for a generated workspace once distributed `.NET` support is released.
- FR-41: The product must define one standard workspace and layer structure that can be used across supported languages.
- FR-42: `nfw add service --lang go` and `nfw add service --lang rust` must generate services that conform to the shared workspace standard once polyglot support is released.
- FR-43: `nfw sync` must regenerate shared contract artifacts from Protobuf definitions for supported languages once contract sync is released.
- FR-44: The framework must support gRPC for synchronous inter-service contracts in the polyglot expansion phase.
- FR-45: The framework must support Dapr-backed pub/sub for asynchronous inter-service communication in the polyglot expansion phase.
- FR-46: Documentation must explain setup, architecture rules, generator usage, supported feature options, abstraction-plus-adapter design, and troubleshooting for generated projects.

## 9. Non-Goals (Out of Scope)

- Supporting ASP.NET MVC or controller-based scaffolding in the initial product.
- Providing runtime reflection fallbacks for framework features that are expected to be compile-time generated.
- Supporting every database, queue, cache, or cloud provider in the first release.
- Replacing Dapr with provider-specific abstractions inside the domain or application layers.
- Shipping a graphical UI for project generation or orchestration.
- Generating arbitrary non-standard project layouts outside the NFramework standard structure.
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
- Template discovery, template versioning, and template installation rules should be deterministic so generated workspaces are reproducible.
- Source generators and analyzers will likely be required together: generators to create code, analyzers to enforce rules and emit diagnostics.
- Native AOT and trimming compatibility must be validated continuously in CI rather than assumed from design alone.
- CQRS dispatch and messaging flow should be implemented as first-party NFramework capabilities so the product controls AOT compatibility, performance, and public abstractions directly.
- Application workflow contracts should cover the common handler concerns that the generator can opt into, including caching, logging, transaction, and secured-operation behavior.
- The abstract repository layer should remain independent from any specific ORM or query library while still covering paging, dynamic filtering, bulk work, and migration application.
- Topic abstractions must be expressive enough for common framework workflows without forcing core layers to know library or provider implementation details.
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

## 13. Delivery Planning

Delivery sequencing, milestones, and phase boundaries are maintained in [ROADMAP.md](./ROADMAP.md).

The PRD defines product scope, requirements, success metrics, and open questions. The roadmap owns the phased rollout plan.

## 14. Open Questions

- Should the CLI be implemented in Go or Native AOT C# for the first public release?
- Is Dapr mandatory in all generated distributed solutions, or optional but first-class?
- Which topics require first-class NFramework abstractions in the initial beta, and which should remain simple integrations?
- Which popular libraries should receive first-party adapter support in the initial beta?
- Which of the remaining `.NET` integration topics, if any, are acceptable to ship shortly after beta rather than inside the first beta cut?
- Should `nfw add entity` also generate migrations, test fixtures, and sample seed data, or stop at code scaffolding?
- Should `nfw templates` be limited to built-in templates at first, or support remote template catalogs from the first public release?
- What is the exact boundary between the beta promise and post-beta polyglot support for Go and Rust?
- Which benchmark environment defines the official startup-time and CLI-speed KPIs?
