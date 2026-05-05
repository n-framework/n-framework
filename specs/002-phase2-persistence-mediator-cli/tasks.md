# Downstream Specification Tasks

This document identifies the module-level specifications that must be created to implement the Phase 2 orchestrator specification for the compile-time application model.

## Approach: Package-by-Package

Each package is developed **end-to-end** before moving to the next:

- Abstractions (interfaces, base types)
- Implementations (technology-specific adapters)
- Source generators (Roslyn incremental generators)
- CLI templates (tera templates in nfw-templates)
- Tests (unit and integration)

## Package Structure

```text
src/core-persistence-dotnet/
├── NFramework.Persistence.Abstractions/
├── NFramework.Persistence.EFCore/
└── NFramework.Persistence.Generators/

src/core-mediator-dotnet/
├── NFramework.Mediator.Abstractions/
├── NFramework.Mediator.Mediator/
└── NFramework.Mediator.Generators/

src/nfw/  (already exists)
```

---

## P1 — Mediator Package

### P1-T001

- [x] Create spec topic in `src/core-mediator-dotnet/specs/` with spec instruction: Define the `NFramework.Mediator.Abstractions` NuGet package providing CQRS abstractions including marker interfaces, handler interface, pipeline behavior interface, event interface, and mediator interface; ensure zero dependency on infrastructure packages; include unit tests proving compile-time handler discovery.

_Maps to_: US1, US4, FR-002, FR-019

### P1-T002

- [x] Create spec topic in `src/core-mediator-dotnet/specs/` with spec instruction: Define the `NFramework.Mediator.Mediator` NuGet package providing adapter implementation for [martinothamar/Mediator](https://github.com/martinothamar/Mediator) with custom pipeline behaviors for validation, transactions, and logging; support behavior execution order and short-circuiting; ensure compatibility with MediatR v12+; include unit tests proving behavior execution.

_Maps to_: US4, FR-020, FR-021, FR-022

### P1-T003

- [x] Create spec topic in `src/core-mediator-dotnet/specs/` with spec instruction: Define the `NFramework.Mediator.Generators` source generator package using incremental Roslyn API to discover handler implementations and emit DI registration code; emit diagnostics for unsupported patterns; ensure generated code is trimmable and AOT-compatible; include golden-file tests and AOT build validation.

_Maps to_: US2, FR-007, FR-009, FR-011

---

## P2 — Persistence Package

### P2-T001

- [x] Create spec topic in `src/core-persistence-dotnet/specs/` with spec instruction: Define the complete `NFramework.Persistence` package providing repository abstractions, entity base classes, pagination, Entity Framework Core implementation, and source generators: (1) Abstractions - repository abstractions, entity base classes, and pagination interfaces; support CRUD operations, transactions, dynamic querying, and bulk operations; ensure zero coupling to specific persistence implementations; include unit tests with in-memory fakes. (2) EFCore - Entity Framework Core implementation of repository abstractions with DbContext injection, unit of work, and configuration extensions; support ChangeTracker integration and eager loading; include integration tests with SQLite in-memory database. (3) Generators - source generator using incremental Roslyn API to discover repository interface declarations and emit DI registration code; emit diagnostics for configuration errors; ensure generated code is trimmable and AOT-compatible; include golden-file tests and AOT build validation.

_Maps to_: US1, US2, FR-004, FR-007, FR-009

---

## P3 — CLI Commands (nfw)

### P3-T001

- [x] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw add command <NAME> <FEATURE>` command with interactive prompts for options; support `--no-input` flag and `--project` parameter; generate command record and handler class following documented conventions; validate generated code compiles; complete in <5 seconds; include integration tests.

_Maps to_: US3, US19, FR-012, FR-016, FR-018

### P3-T002

- [x] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw add query <NAME> <FEATURE>` command with interactive prompts; support `--no-input` and `--project` flags; generate query record and handler class; follow layer placement conventions; complete in <3 seconds; include integration tests.

_Maps to_: US3, US19, FR-013

### P3-T003

- [x] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw add entity <NAME> --props <DEFINITIONS>` command that generates an entity class with properties, ID type, and base class inheritance; support `--id-type` parameter for custom ID types; place entity in the Domain layer following naming conventions; generate property validation attributes; support value object properties; complete in <3 seconds; include integration tests.

_Maps to_: US3, FR-007, FR-014

### P3-T004

- [x] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw gen repository <NAME>` command that generates a repository interface for an existing entity; support `--feature` parameter to target specific feature folder; generate generic IRepository<T, TId> interface with CRUD methods; place in Application layer following conventions; validate entity exists before generation; complete in <2 seconds; include integration tests.

_Maps to_: US3, FR-014, FR-023

### P3-T005

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw gen endpoint <OPERATION_TYPE> <NAME> <FEATURE>` command that generates HTTP endpoint boilerplate for existing commands or queries; support GET/POST/PUT/DELETE mapping based on operation type; generate Minimal API route definitions with proper attribute routing; support `--secured` flag for authorization; generate OpenAPI documentation annotations; place in API layer following conventions; validate referenced command/query exists; complete in <3 seconds; include integration tests.

_Maps to_: US3, FR-007, FR-019

### P3-T006

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw gen crud <NAME> --props <DEFINITIONS>` command that generates complete CRUD scaffolding by orchestrating entity, repository, commands, queries, handlers, DTOs, and API endpoints; support `--id-type` parameter; create feature folder structure automatically; generate all required files in correct layers; validate generated code compiles as a unit; complete in <10 seconds; include integration tests for full CRUD flow.

_Maps to_: US3, FR-007, FR-014

### P3-T007

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw check` command that validates workspace architecture rules by scanning for forbidden dependencies, namespace violations, and banned packages; exit with non-zero status when violations found; provide actionable error messages; support `--ci` and `--verbose` flags; complete in <2 seconds; include integration tests.

_Maps to_: US5, FR-023, FR-024

### P3-T009

- [x] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw add mediator` command that adds the Mediator module to an existing service; support interactive prompts for service selection; support `--service` parameter to specify target service and `--no-input` flag for automation; update `nfw.yaml` to register the mediator module; execute template rendering for mediator artifacts; preserve YAML comments on rollback; complete in <5 seconds; include integration tests covering successful addition, rollback on failure, service validation, and YAML comment preservation.

_Maps to_: US3, FR-012, FR-016, FR-018

### P3-T010

- [x] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw add persistence` command that adds the Persistence module to an existing service; support interactive prompts for service selection; support `--service` parameter to specify target service and `--no-input` flag for automation; update `nfw.yaml` to register the persistence module; execute template rendering for persistence artifacts including DbContext, repository base classes, and configuration; preserve YAML comments on rollback; complete in <5 seconds; include integration tests covering successful addition, rollback on failure, service validation, and YAML comment preservation.

_Maps to_: US3, FR-004, FR-012, FR-016, FR-018

### P3-T011

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Implement the `nfw add webapi` command that adds the WebAPI module to an existing service; support interactive prompts for service selection; support `--service` parameter to specify target service and `--no-input` flag for automation; update `nfw.yaml` to register the webapi module; execute template rendering for API layer artifacts including Minimal API startup configuration, route registration extensions, CORS middleware, health check endpoints, and problem details middleware; generate OpenAPI/Swagger configuration; preserve YAML comments on rollback; complete in <5 seconds; include integration tests covering successful addition, rollback on failure, service validation, and YAML comment preservation.

_Maps to_: US8, US23, FR-019, FR-020, FR-031

---

## Package Dependencies

```text
P1: core-mediator-dotnet (foundational CQRS)
  ↓
P2: core-persistence-dotnet (depends on Mediator abstractions)
  ↓
P3: nfw CLI (orchestrates both packages)
```

---

## Implementation Strategy

### MVP Scope

**Complete packages in order:**

1. P1 (Mediator)
2. P2-T001 (Persistence)
3. P3-T001 to P3-T006 (nfw CLI generation commands)
4. P3-T007 to P3-T008 (validation and templates)
5. P3-T009 to P3-T011 (add module commands)

**MVP validates:**

- Abstractions work
- Source generators emit trimmable code
- CLI generates compilable artifacts
- Individual commands compose correctly for CRUD
- AOT publishing succeeds

### Incremental Delivery

Each package is independently testable and releasable:

- P1 releases first
- P2 releases after P1
- P3 releases incrementally (per command capability)

### Parallel Execution Opportunities

**Within P1:**

- P1-T001 must complete first
- P1-T002 and P1-T003 can run in parallel after P1-T001

**Within P2:**

- Single task P2-T001 covers all persistence package deliverables

**Within P3:**

- P3-T008 must complete first (templates foundation)
- P3-T001, P3-T002 can run in parallel after P3-T008
- P3-T003, P3-T004, P3-T005 can run in parallel after P3-T008
- P3-T006 (CRUD orchestration) must complete after P3-T003, P3-T004, P3-T005
- P3-T007 (check) can run in parallel after P3-T008

### Task Dependencies for CRUD

The CRUD command (P3-T006) orchestrates the granular commands:

```
P3-T003 (add entity)     → Entity class generation
P3-T004 (add repository) → Repository interface generation
P3-T001 (add command)    → Create/Update/Delete commands
P3-T002 (add query)      → GetById/GetAll queries
P3-T005 (add api)        → HTTP endpoint generation
```

P3-T006 combines these capabilities into a single workflow that:

1. Validates input properties
2. Generates entity (delegates to P3-T003 logic)
3. Generates repository interface (delegates to P3-T004 logic)
4. Generates CRUD commands (delegates to P3-T001 logic)
5. Generates CRUD queries (delegates to P3-T002 logic)
6. Generates API endpoints (delegates to P3-T005 logic)
7. Validates complete output compiles

---

## Success Criteria Tracking

Each specification must reference relevant success criteria:

- **SC-001**: Generated code is Native AOT compatible
- **SC-002**: No runtime reflection for handler discovery
- **SC-005**: Entity generation <3s, repository <2s, command <5s, query <3s, API <3s, full CRUD <10s
- **SC-006**: Architecture validation <2s
- **SC-010**: Zero coupling from domain to infrastructure
- **SC-011**: Support empty handler sets without errors

---

## Notes

- Each package creates a **single specification** with multiple tasks
- Use the exact spec instruction text when creating downstream specifications
- Refer to the parent orchestrator spec (`spec.md`) for complete context
- Templates live in `src/nfw-templates/` with tera format and configuration files
- nfw reads template configurations to drive generation flow (no hardcoded logic)
- All source generators must use `IIncrementalGenerator` API
- Generated code placed in `.g.cs` files with `generated` attribute
- Package versions follow semantic versioning
- CRUD generation is an orchestrator command that composes granular generation commands
- Individual commands can be used standalone for fine-grained control
- Template metadata defines composition rules for CRUD scaffolding

---

## External Dependencies

**martinothamar/Mediator**: Used as the underlying MediatR implementation. Our adapter provides custom pipeline behaviors and integration with our abstractions.
