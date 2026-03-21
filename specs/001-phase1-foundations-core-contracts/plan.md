# Implementation Plan: Phase 1 Foundations and Core Contracts

**Branch**: `001-phase1-foundations-core-contracts` | **Date**: 2026-03-16 | **Spec**: [`spec.md`](./spec.md)
**Spec Type**: Monorepo
**Project**: N/A
**Input**: Feature specification from [`spec.md`](./spec.md)

## Summary

Initial establishes the first usable NFramework path for standalone services. The plan coordinates three streams: extending the existing `src/nfw` module to support template-aware workspace creation and standalone service scaffolding, introducing dedicated shared contract modules for `NFramework.Domain` and `NFramework.Application`, and adding root-level orchestration assets so the repository exposes one documented build command and one documented test command for generated workspaces. Project-level follow-up specs in each affected module are a blocking first step before implementation changes land in those modules.

## Technical Context

**Language/Version**: C# on .NET 11 for CLI and shared contracts; Bash for repository-root developer entrypoints; Markdown for orchestration specs and contracts  
**Primary Dependencies**: Spectre.Console.Cli, Spectre.Console, Microsoft.Extensions.DependencyInjection, Microsoft.Extensions.Http, YamlDotNet, xUnit, FluentAssertions  
**Storage**: File system only for template catalogs, generated workspace assets, documentation, and validation artifacts  
**Testing**: xUnit-based module tests in `src/nfw`, plus deterministic generated-workspace smoke tests invoked from a single repository-root test command  
**Target Platform**: Linux, macOS, and Windows developer environments running the standalone service workflow locally  
**Project Type**: Monorepo orchestrator coordinating one existing CLI module (`src/nfw`) and new shared contract modules under `src/`  
**Performance Goals**: Template discovery, workspace creation, and first-service scaffolding must support the Initial success criteria, including a first-time end-to-end flow in 10 minutes or less and first-run generated build/test success for fresh workspaces  
**Constraints**: Root build/test entrypoints are mandatory; CLI stdout/stderr and exit-code behavior must remain stable; unit tests cannot require real network access; Initial excludes advanced generators, distributed runtime features, and polyglot support  
**Scale/Scope**: One monorepo spec coordinating root docs/scripts, the `src/nfw` module, and two new shared contract modules for the initial standalone service path

## Constitution Check

_GATE: Must pass before Phase 0 research. Re-check after Initial design._

### Pre-Research Gate Review

- **Single-Step Build And Test**: PASS. Initial will add repository-root build and test entrypoints and require generated workspaces to expose the same single-command behavior.
- **CLI I/O And Exit Codes**: PASS. The existing `src/nfw` CLI contract already defines stdout/stderr separation and stable exit codes; Initial extends that contract to `templates`, `new`, and `add service`.
- **No Suppression**: PASS. The plan uses normal compiler/test feedback and does not rely on suppressed warnings, swallowed exceptions, or disabled tests.
- **Deterministic Tests**: PASS. Unit tests remain offline, and generated-workspace validation uses local fixtures or checked-in templates rather than live network dependencies.
- **Documentation Is Part Of Delivery**: PASS. This plan includes a quickstart and explicit CLI/workspace contracts, and the generated workspace must carry executable build/test instructions.

## Project Structure

### Documentation (this feature)

```text
specs/001-phase1-foundations-core-contracts/
├── spec.md
├── plan.md
└── tasks.md
```

### Source Code (repository root)

```text
docs/
├── PRD.md
├── ROADMAP.md
└── SPECIFICATION_GUIDELINES.md

scripts/
├── build.sh                  # new root build entrypoint
├── test.sh                   # new root test entrypoint
├── deps.sh
├── format.sh
└── lint.sh

specs/
└── 001-phase1-foundations-core-contracts/

src/
├── nfw/                      # existing CLI/workspace module submodule
│   ├── src/NFramework.NFW/
│   ├── tests/
│   └── specs/
├── NFramework.Domain/        # new shared domain-contract module submodule
└── NFramework.Application/   # new shared application-contract module submodule
```

**Structure Decision**: Use a monorepo orchestrator structure. `src/nfw` owns public CLI workflows and generated workspace/service assets. `src/NFramework.Domain` and `src/NFramework.Application` become dedicated shared-contract modules rather than remaining CLI-internal packages, which keeps the core contracts reusable by generated services and preserves clean ownership boundaries at the repository level.

## Planning Decisions

This plan resolves the core decisions that shape the Initial project-spec set:

1. Shared contract ownership lives in dedicated module repositories, not inside the CLI module.
2. Template selection stays deterministic by using explicit identifiers in non-interactive mode and prompt-based selection only in interactive terminals.
3. Repository-root wrapper scripts become the official one-command build and test entrypoints for the orchestrator and generated workspaces.
4. Initial boundary enforcement is structural and documentation-backed rather than analyzer- or generator-heavy.
5. Public contracts for the CLI and generated workspace are documented before tasks are written.
6. The standalone service baseline includes a starter health or readiness endpoint.
7. The minimal shared application contract set is `Result`, `Result<T>`, `ICommand<TResponse>`, and `IQuery<TResponse>`.

The resulting decisions are reflected directly in [`spec.md`](./spec.md) and [`tasks.md`](./tasks.md).

## Implementation Strategy

### Stream A: CLI and Workspace Flows (`src/nfw`)

- Extend the existing CLI skeleton with `nfw new` and `nfw add service`.
- Keep template discovery, prompt behavior, argument validation, and stderr/stdout rules inside the CLI surface.
- Keep CLI-local request models and template/application services under `NFramework.NFW.*` for the CLI module, while generating workspace assets and standalone service baselines that already comply with the documented boundary rules.
- Generate standalone service baselines with a starter health or readiness endpoint and interruption-safe cleanup behavior.

### Stream B: Shared Core Contracts (`src/NFramework.Domain`, `src/NFramework.Application`)

- Create dedicated shared modules for domain and application contracts.
- Move or re-express the baseline abstractions so generated services depend on framework-level contract packages rather than CLI-internal assemblies.
- Keep the application result model and the Initial contract set of `ICommand<TResponse>` and `IQuery<TResponse>` free of infrastructure dependencies.

### Stream C: Orchestrator Consumption (repository root)

- Add root `scripts/build.sh` and `scripts/test.sh`.
- Document and validate the generated workspace onboarding flow from repository root and from a freshly generated sample workspace.
- Add smoke validation for generated workspaces, shared-contract compile examples, and first-run onboarding verification.
- Pin the relevant module revisions in the root repository once project-level implementations land.

## Post-Design Constitution Check

- **Single-Step Build And Test**: PASS. The design requires root wrapper scripts and the same convention in generated workspaces.
- **CLI I/O And Exit Codes**: PASS. The CLI contract explicitly preserves stdout for normal output, stderr for diagnostics, and stable exit-code expectations.
- **No Suppression**: PASS. The design does not introduce warning suppression, hidden failures, or ignored tests.
- **Deterministic Tests**: PASS. The quickstart and workspace contract both assume offline-friendly fixtures for tests and no unit-test network dependency.
- **Documentation Is Part Of Delivery**: PASS. The root spec, plan, and topic backlog remain aligned and require executable onboarding/build/test guidance in the downstream project specs.

## Complexity Tracking

No constitution violations require justification for this plan.
