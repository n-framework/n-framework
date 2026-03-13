# NFramework Roadmap

This document translates the current product direction into a delivery roadmap.

It is intentionally narrower than the PRD:

- It focuses on delivery order and milestone boundaries
- It keeps the initial beta scoped to .NET services
- It pushes distributed microservice features and polyglot support to post-beta phases

For the full product definition, see [PRD.md](./PRD.md).

## Current Direction

NFramework is being developed as a compile-time-first framework and workspace standard for modern services.

The current execution strategy is:

- Initial beta focuses only on .NET services
- The first release proves the core architecture, developer workflow, generator tooling, and main `.NET` service capabilities
- Distributed .NET microservice features come after the initial beta
- Polyglot expansion comes after the .NET service path is stable

## What Initial Beta Includes

The initial beta is limited to the .NET service path.

Included in beta:

- [ ] `nfw templates` and template-aware workspace creation
- [ ] `nfw` workspace creation and .NET service scaffolding
- [ ] Entity generation and standard CRUD flow generation
- [ ] Standalone command and query generation
- [ ] `NFramework.Domain` and `NFramework.Application`
- [ ] Framework-native CQRS execution flow
- [ ] Application workflow contracts for business rules, pageable requests, and opt-in handler features
- [ ] Topic-specific abstractions used across the codebase
- [ ] Adapter-based integration points for supported libraries and providers
- [ ] Abstract repository contracts with paging, dynamic query support, bulk operations, and migration hooks
- [ ] Security contracts for authentication, authorization, operation claims, refresh tokens, and authenticators
- [ ] Validation, mapping, logging, problem details, localization, translation, mailing, SMS, and search abstractions plus initial adapters
- [ ] Source-generated DI registration
- [ ] Source-generated Minimal API route generation
- [ ] Architecture validation through `nfw check`
- [ ] One-command build and one-command test workflows
- [ ] Documentation required to create and extend a .NET service

Explicitly not part of the initial beta:

- Aspire AppHost and ServiceDefaults
- Dapr adapters
- Local orchestration for distributed development
- Go service scaffolding
- Rust service scaffolding
- Protobuf sync and polyglot contract workflows

## Phase 1: Foundations and Core Contracts

Target window: March-April 2026

Goal:
Establish the core framework shape and the first usable CLI workflow for standalone .NET services.

Planned deliverables:

- [ ] Initial `nfw` CLI skeleton
- [ ] Template catalog and `nfw templates`
- [ ] Workspace creation
- [ ] .NET service scaffolding
- [ ] `NFramework.Domain`
- [ ] `NFramework.Application`
- [ ] Baseline Result pattern
- [ ] Baseline topic package boundaries
- [ ] Baseline architecture rules

Exit criteria:

- [ ] A new `.NET` workspace and service can be created from the CLI
- [ ] Generated projects follow the intended layer boundaries
- [ ] Core abstractions are usable without infrastructure dependencies
- [ ] Template selection works in both interactive and non-interactive flows
- [ ] The project has a documented single build command and single test command

## Phase 2: Generator and .NET Service Beta

Target window: May-June 2026

Goal:
Turn the `.NET` service path into a coherent beta release with generator tooling, framework-native workflows, and the main service capabilities.

Planned deliverables:

- [ ] Entity-to-CRUD generation for .NET services
- [ ] Standalone command generation
- [ ] Standalone query generation
- [ ] Generator options for caching, logging, transaction, secured operation, and API exposure
- [ ] Source-generated DI registration
- [ ] Source-generated Minimal API route mapping
- [ ] Framework-native CQRS execution pipeline
- [ ] Application workflow contracts for business rules, pageable requests, and opt-in handler features
- [ ] Initial topic abstractions
- [ ] Abstract repository layer with paging, dynamic querying, bulk operations, and migration hooks
- [ ] Security foundations for JWT, refresh tokens, operation claims, authorization, and authenticators
- [ ] Validation, mapping, logging, problem details, localization, translation, mailing, SMS, and search abstractions plus first adapters
- [ ] `nfw check` for architecture validation
- [ ] First beta release for the .NET service path

Exit criteria:

- [ ] A generated `.NET` service can expose entity, command, and query flows with minimal manual setup
- [ ] Generated code builds and tests with the documented commands
- [ ] Architecture violations are detected through automated checks
- [ ] Core `.NET` service capabilities are represented through NFramework abstractions and initial adapters
- [ ] The beta scope is documented clearly enough for external adopters

## Phase 3: Post-Beta .NET Integrations and Microservice Features

Target window: July 2026+

Goal:
Complete the remaining `.NET` integration work and then expand from standalone `.NET` services into distributed `.NET` microservice workflows.

Planned deliverables:

- [ ] Any remaining `.NET` integration packs that did not make the beta cut
- [ ] Aspire defaults
- [ ] Dapr adapters
- [ ] `nfw up` for local orchestration
- [ ] Documentation for distributed .NET service development

Exit criteria:

- [ ] Developers can boot a distributed .NET development environment with the documented workflow
- [ ] Service-to-service and platform integrations use NFramework abstractions and adapters
- [ ] Standalone `.NET` service capabilities remain coherent after the post-beta integrations land
- [ ] Distributed concerns remain outside domain and application layers

## Phase 4: Polyglot Expansion

Target window: Post-beta, after the .NET service path is stable

Goal:
Extend the framework standard beyond .NET while preserving the same architectural model.

Planned deliverables:

- [ ] Go service scaffolding
- [ ] Rust service scaffolding
- [ ] `nfw sync` for Protobuf-driven contract generation
- [ ] Shared contract workflows across languages
- [ ] Stabilized polyglot local orchestration patterns

Exit criteria:

- [ ] At least two supported languages can follow the same NFramework structure
- [ ] Shared contracts can be regenerated through one workflow
- [ ] Language expansion does not weaken the existing .NET service path

## Cross-Cutting Priorities

These priorities apply across all phases:

- [ ] Keep domain and application layers independent from implementation-specific libraries
- [ ] Keep the `.NET` service path coherent as abstractions, adapters, and generators expand
- [ ] Prefer framework abstractions plus adapters over direct library coupling
- [ ] Maintain Native AOT and trimming compatibility as product-level constraints
- [ ] Keep generated code readable and reviewable
- [ ] Keep build and test workflows simple and repeatable

## Open Decisions

The roadmap still depends on several product decisions:

- [ ] Final implementation language for the CLI
- [ ] Which topics need first-class abstractions in beta
- [ ] Which popular libraries should receive first-party adapter support first
- [ ] How much code generation should be included in `nfw add entity`
- [ ] Which remaining `.NET` integration packs, if any, can ship shortly after beta instead of inside the first beta cut
- [ ] Whether template distribution should be built-in only at first or support remote catalogs from the initial public release
- [ ] When distributed .NET features are mature enough to move from post-beta plan into committed delivery

## Notes

- This roadmap is directional and should be updated when scope changes in the PRD.
- If the beta scope expands, the roadmap should be revised explicitly rather than allowing implicit drift.
