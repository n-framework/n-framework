# Implementation Plan: Compile-Time Application Model

**Branch**: `002-phase2-persistence-mediator-cli` | **Date**: 2026-04-10 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/002-phase2-persistence-mediator-cli/spec.md`

**Note**: This is an orchestrator specification coordinating Phase 2 work across multiple topic-based packages. Each package is developed end-to-end (abstractions + implementations + generators + templates) before moving to the next.

## Summary

Phase 2 delivers the compile-time-first application model for the .NET reference implementation using a **package-by-package** approach:

1. **Persistence** (P1): Entity base classes, Repository abstractions, EF Core implementation, registration source generators
2. **CQRS Mediator** (P2): Command/query abstractions, MediatR adapter, handler registration and routing source generators
3. **CLI Integration** (P3): `nfw` CLI commands for generating commands, queries, entities with Handlebars templates
4. **Diagnostic Analyzer** (P4): Roslyn analyzer for AOT compatibility and architecture validation

**Technical Approach**: Each topic package is complete end-to-end before moving to the next. Source generators replace runtime reflection for DI/routing.

## Package Structure

```text
src/core-persistence-dotnet/
├── NFramework.Persistence.Abstractions/     # IRepository<T, TId>, IPagedResult<T>, IUnitOfWork
├── NFramework.Persistence.EFCore/           # Entity Framework Core implementation
└── NFramework.Persistence.Generators/       # Repository registration source gen

src/core-mediator-dotnet/
├── NFramework.Mediator.Abstractions/        # IMediator, IPipelineBehavior, ICommand<TResult>, IQuery<TResult>
├── NFramework.Mediator.Mediator/            # Adapter for martinothamar/Mediator package
└── NFramework.Mediator.Generators/          # Handler discovery & registration source gen

src/nfw/  (already exists - Rust CLI with Handlebars templates)
```

## Technical Context

**Language/Version**:

- .NET 11 with C# 14/15 features for core packages and source generators
- Rust 1.85+ (2024 edition) for `nfw` CLI

**Primary Dependencies**:

- .NET: Roslyn source generator APIs (`Microsoft.CodeAnalysis.CSharp`), analyzer diagnostic APIs
- .NET: [martinothamar/Mediator](https://github.com/martinothamar/Mediator) v12+ for CQRS implementation
- Rust: Existing `nfw` CLI infrastructure (clap, ratatui, crossterm, inquire, tera)
- Build: Native AOT publishing tooling, dotnet format

**Storage**:

- Configuration: YAML workspace configuration files (existing pattern in `nfw`)
- Templates: Mustache templates and configurations in `src/nfw-templates/` submodule

**Testing**:

- .NET: xUnit + build fixtures for golden-file testing of generated code
- Rust: cargo test with integration tests in `src/nfw/tests/`
- Validation: CI checks for AOT/trimming warnings

**Target Platform**:

- .NET 11 runtime (Linux container baseline for benchmarks)
- Native AOT publishing for cloud-native deployment
- CLI tools cross-platform (Linux, macOS, Windows)

**Project Type**: Framework SDK (core packages + code generators + developer tooling)

**Performance Goals**:

- Service cold-start: <50ms (Docker, 2 CPU, 4GB RAM)
- Command generation: <5s from invocation to buildable output
- CRUD generation: <10s from invocation to buildable output

**Constraints**:

- Zero Native AOT warnings in all core packages
- Zero trimming warnings in generated code
- No runtime assembly scanning for DI registration
- All abstractions must have zero external package dependencies

**Scale/Scope**:

- 2 topic packages (Persistence, Mediator) with multiple NuGet packages each
- Source generators in each topic package for registration/routing
- 4+ CLI commands (add command, add query, add entity, check)
- Supports .NET service projects with 100+ handlers efficiently

## Constitution Check

_GATE: Must pass before Phase 0 research. Re-check after Phase 1 design._

### I. Single-Step Build And Test

| Requirement                              | Status  | Notes                                                                             |
| ---------------------------------------- | ------- | --------------------------------------------------------------------------------- |
| System builds with single command        | ✅ PASS | Framework packages use standard `.csproj` build; CLI uses `cargo build`           |
| Full test suite runs with single command | ✅ PASS | `dotnet test` for packages; `cargo test` for CLI; root-level orchestration script |
| Commands documented from repo root       | ✅ PASS | PRD defines `make build` and `make test` conventions                              |

### II. CLI I/O And Exit Codes

| Requirement                  | Status  | Notes                                        |
| ---------------------------- | ------- | -------------------------------------------- |
| Normal output to stdout      | ✅ PASS | Specified in PRD CLI requirements            |
| Diagnostics/errors to stderr | ✅ PASS | Standard Rust/CLI conventions                |
| Stable exit codes documented | ✅ PASS | Success (0), errors (non-zero), SIGINT (130) |

### III. No Suppression

| Requirement                         | Status  | Notes                                                  |
| ----------------------------------- | ------- | ------------------------------------------------------ |
| No suppressing compiler warnings    | ✅ PASS | SC-001/SC-002 require zero AOT/trimming warnings       |
| No skipping/disabling failing tests | ✅ PASS | Test fixtures defined in FR-026                        |
| No swallowing exceptions            | ✅ PASS | FR-003/FR-021 require explicit error handling patterns |

### IV. Deterministic Tests

| Requirement                        | Status  | Notes                                              |
| ---------------------------------- | ------- | -------------------------------------------------- |
| Unit tests avoid real network      | ✅ PASS | FR-026 specifies build fixtures (no external deps) |
| Integration tests isolated/labeled | ✅ PASS | Golden-file testing for generated code             |

### V. Documentation Is Part Of Delivery

| Requirement                        | Status  | Notes                                                |
| ---------------------------------- | ------- | ---------------------------------------------------- |
| CLI quickstarts for build/run/test | ✅ PASS | FR-027/FR-028 require documented build/test commands |
| No contradictory guidance          | ✅ PASS | Spec-driven development ensures consistency          |

### Additional Constraints

| Requirement                      | Status  | Notes                                                                   |
| -------------------------------- | ------- | ----------------------------------------------------------------------- |
| Preserves repository conventions | ✅ PASS | Builds on Phase 1 workspace structure; extends existing CLI patterns    |
| Measurable outcomes validated    | ✅ PASS | SC-001 through SC-010 all measurable; plan includes validation approach |

**Overall Gate Status**: ✅ ALL GATES PASS - Proceed to implementation

## Project Structure

This is an **orchestrator specification** coordinating work across multiple topic-based packages. Each package is a submodule that will contain its own specifications.

### Documentation (this feature)

```specs/002-phase2-persistence-mediator-cli/
├── spec.md              # Feature specification (user stories, requirements, success criteria)
├── plan.md              # This file (orchestrator view and technical approach)
└── tasks.md             # Downstream package specifications (P1-P3)
```

### Source Code (repository root - meta-repo level)

The meta-repo orchestrates but does not directly implement Phase 2 features. Implementation occurs in downstream submodules:

```# Phase 2 Package Specifications (created via tasks.md)
src/core-persistence-dotnet/specs/
├── 001-entity-repository-abstractions/  # Entity and repository abstractions
├── 002-efcore-implementation/            # EF Core repository implementation
└── 003-repository-generators/            # Repository registration source gen

src/core-mediator-dotnet/specs/
├── 001-cqrs-abstractions/               # CQRS abstractions
├── 002-mediatr-adapter/                  # Adapter for martinothamar/Mediator
└── 003-handler-generators/               # Handler discovery & registration source gen

src/nfw/specs/
├── 003-cli-generation-commands/          # `nfw add command/query/crud` commands
└── 004-build-validation/                 # `nfw check` architecture validation
```

**Structure Decision**: This orchestrator spec defines the contract and integration points. Individual package specs in each submodule repository will contain implementation details (project structure, source files, tests). The meta-repo tracks submodule pinning and validates cross-package integration.

## Package Dependencies

```P1: core-persistence-dotnet (foundational)
  ↓
P2: core-mediator-dotnet (depends on Persistence; uses martinothamar/Mediator)
  ↓
P3: nfw CLI (orchestrates both packages via nfw-templates)
```

## Implementation Strategy

### Package-by-Package Approach

Each package is developed **end-to-end** before moving to the next:

1. **Abstractions** (interfaces, base types, contracts)
2. **Implementations** (technology-specific adapters or external library integration)
3. **Source Generators** (Roslyn incremental generators)
4. **CLI Templates** (tera templates in `nfw-templates`)
5. **Tests** (unit and integration)

### MVP Scope (Minimum Viable Product)

**Complete packages in order:**

1. P1 (Persistence) — Entity base classes, Repository abstractions, EF Core implementation
2. P2-T001 to P2-T003 (Mediator) — CQRS abstractions, MediatR adapter, handler registration generator
3. P3-T001 to P3-T003 (nfw CLI) — add command/query/crud commands

**MVP validates:**

- Entity and Repository abstractions work
- Source generators emit trimmable code
- CLI generates compilable artifacts
- AOT publishing succeeds

### Incremental Delivery

Each package is independently testable and can be released separately:

- P1 releases first (foundational)
- P2 releases after P1 (uses Entity, AggregateRoot)
- P3 releases incrementally as templates are added

### Parallel Execution Opportunities

**Within P1 (Persistence):**

- P1-T001 (Abstractions + Entity/AggregateRoot) must complete first
- P1-T002 (EFCore) and P1-T003 (Generators) can run in parallel after P1-T001

**Within P2 (Mediator):**

- P2-T001 (Abstractions) must complete first
- P2-T002 (MediatR Adapter) and P2-T003 (Handler Generators) can run in parallel after P2-T001

**Within P3 (CLI):**

- P3-T005 (Templates) must complete first
- P3-T001 to P3-T003 (CLI commands) and P3-T004 (check command) can run in parallel after P3-T005

## Complexity Tracking

> **No violations** - All constitution gates passed without requiring justifications.

## Notes

**Excluded from Phase 2**: Cross-cutting concerns package (`Result<T>`, validators, mappers, cache, logging) and security abstractions. These will be addressed in later phases as separate packages.

**MediatR Integration**: We use [martinothamar/Mediator](https://github.com/martinothamar/Mediator) (the community fork of MediatR) as the underlying CQRS implementation. Our `NFramework.Mediator.Mediator` package provides an adapter layer with:

- Custom pipeline behaviors for cross-cutting concerns
- Extension methods for service registration
- Compatibility shims for our abstractions
- Built-in behaviors for validation, transactions, and logging

This approach leverages the battle-tested MediatR library while maintaining our architectural patterns.

**Generators**: Source generators are part of each topic package, ensuring tight coupling between abstractions and their code generation.

**Templates**: CLI templates live in `src/nfw-templates/` submodule with tera format and configuration files. nfw reads template configurations to drive generation flow without hardcoded logic. Templates are version-controlled in the nfw-templates submodule.

**Naming Convention**:

- Repository folders: `core-*-dotnet` (GitHub org style)
- Package names: `NFramework.*` (namespace prefix)

**Minimal Orchestrator Spec**: This spec focuses on coordination between packages. Detailed design artifacts (data models, API contracts, research findings) belong in individual package specifications, not this orchestrator.
