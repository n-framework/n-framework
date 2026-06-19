# NFramework Roadmap

This document translates the current product direction into a phased delivery roadmap.

It is intentionally narrower than the PRD:

- It focuses on delivery order, milestone boundaries, and release gates
- It keeps the first externally consumable beta scoped to the `.NET` service path
- It separates the beta release gate from lower-priority beta follow-on work when the PRD marks those items as important but not on the critical path
- It keeps distributed `.NET` features, polyglot support, and ecosystem tooling behind a stable standalone `.NET` path
- It assumes the CLI is Rust-based so it stays fast, portable, and easy to extend

For the full product definition, see [PRD.md](./PRD.md).

## Current Direction

NFramework is being developed as a compile-time-first framework and workspace standard for modern services.

The current execution strategy is:

- Initial delivery proves the standalone `.NET 11` reference path first
- The first public beta must validate CLI experience, architecture enforcement, compile-time generation, and Native AOT readiness before distributed features expand the surface area
- Distributed `.NET` microservice features follow only after the standalone `.NET` service path is stable
- Polyglot support follows only after the `.NET` conventions, contract model, and workspace standard are durable
- The CLI layer is planned as Rust tooling that drives the workspace and service workflows
- TUI is deferred until after the .NET framework path is fully proven (workspace, compile-time generation, core capabilities, beta, distributed features, and polyglot)
- MCP-compatible tooling remains part of the product direction, but it should not displace the beta-critical `.NET` workflow

## Planning Assumptions

This roadmap assumes:

- A core delivery team of `4` engineers through beta, expanding to `5` engineers for distributed `.NET` and polyglot phases
- Shared support from `0.5` QA automation throughout the roadmap and `0.5` technical writing support starting in beta hardening
- A Rust CLI engineer owns the CLI layer and keeps interactive and scripted entry points aligned
- Phase boundaries are driven by the priorities in PRD sections `3`, `6`, `11`, and `12`, not by calendar convenience alone
- When PRD sections disagree on sequencing detail, planning follows the more concrete implementation constraints in section `11`, and the dependency is called out explicitly in the relevant phase

## Beta Release Gate

The first public beta is the first point at which the standalone `.NET` service path can be evaluated against the PRD success metrics and core user workflows.

Included in the beta release gate:

- [x] `nfw templates`, `nfw new`, and `nfw add service --template dotnet-service` (Phase 1 ✅)
- [x] One-command build and one-command test workflows for generated samples (Phase 1 ✅)
- [x] Persistence and Mediator packages — `NFramework.Persistence.Abstractions`, `NFramework.Persistence.EFCore`, `NFramework.Mediator.Abstractions`, `NFramework.Mediator.Mediator`, `NFramework.Mediator.Mediator.Generators`, `NFramework.Mediator.Mediator.Validation.FluentValidation` all fully implemented
- [x] Result-based application flow via `UnionRailway` (`Rail<T>`, `UnionError`)
- [x] Framework-native CQRS execution with 8 pipeline behaviors
- [x] Source-generated DI registration and Minimal API route generation
- [x] Architecture validation through `nfw check` (Phase 1 ✅)
- [x] End-to-end feature generation via `nfw gen command`, `nfw gen query`, `nfw gen crud`, `nfw gen entity`, `nfw gen repository`, `nfw gen endpoint`
- [x] Topic abstractions for persistence and mediator ✅. Logging, mapping, caching, OpenAPI, and exception handling deferred to Phase 3
- [ ] Quickstart, architecture guidance, and feature-complete `.NET` documentation
- [x] Continuous validation for Native AOT, trimming, smoke tests, and benchmark KPIs (Phase 1 ✅)

Beta follow-on items that remain in PRD scope but are not on the critical path for the first external beta cut:

- [ ] Localization and translation adapters
- [ ] Mailing adapters
- [ ] Search adapters

---

## Phase Overview

| Phase | Name | Status | Target | Spec |
| ----- | ---- | ------ | ------ | ---- |
| 1 | Workspace and Core Foundations | ✅ Complete | Apr-May 2026 | [spec](../specs/001-phase1-foundations-core-contracts/spec.md) |
| 2 | Compile-Time Application Model | ✅ Complete | Jun-Aug 2026 | [spec](../specs/002-phase2-persistence-mediator-cli/spec.md) |
| 3 | Cross-Cutting Concerns, Logging, and API Routing | Planned | Sep-Dec 2026 | [spec](../specs/003-phase3-cross-cutting-logging-api/spec.md) |
| 4 | Security Abstractions and Implementations | Planned | Jan-Mar 2027 | [spec](../specs/004-phase4-security-abstractions/spec.md) |
| 5 | Diagnostic Analyzers | Planned | Apr-Jun 2027 | [spec](../specs/005-phase5-diagnostic-analyzers/spec.md) |
| 6 | Beta Hardening and Public Beta | Planned | Jul-Sep 2027 | [spec](../specs/006-phase6-beta-hardening/spec.md) |
| 7 | Distributed .NET Expansion | Planned | Apr-Jul 2027 | [spec](../specs/007-phase7-distributed-dotnet/spec.md) |
| 8 | Interactive TUI Interface | Planned | Oct 2027-Jan 2028 | [spec](../specs/008-phase8-interactive-tui/spec.md) |
| 9 | Polyglot Standards and Ecosystem Tooling | Planned | Feb-Jul 2028 | [spec](../specs/009-phase9-polyglot-ecosystem/spec.md) |

---

## Phase 1: Workspace and Core Foundations ✅ COMPLETE

**Target window**: April-May 2026 — **Completed April 2026**

**Goal**: Establish the Rust CLI, workspace shape, service scaffold, template system, architecture validation, and build/test workflows needed for every later generator and adapter investment.

**Full specification**: [specs/001-phase1-foundations-core-contracts/spec.md](../specs/001-phase1-foundations-core-contracts/spec.md)

**Milestones**: M1 (workspace conventions) ✅ · M2 (Rust CLI) ✅ · M3 (architecture rules) ✅

**Performance Results**: Combined workspace + service creation achieves **41ms median** (P95: 46ms), **355x faster** than the 1000ms target.

**Test Coverage**: 20+ integration tests, comprehensive unit tests, 5 smoke test scripts, and benchmark harness all passing. See [docs/phase1-status.md](./phase1-status.md) for detailed completion report.

---

## Phase 2: Compile-Time Application Model ✅ COMPLETE

**Target window**: June-August 2026

**Goal**: Prove the compile-time-first application model by delivering the CQRS pipeline, command/query/CRUD generation, source-generated DI registration, and foundational .NET topic packages.

**Full specification**: [specs/002-phase2-persistence-mediator-cli/spec.md](../specs/002-phase2-persistence-mediator-cli/spec.md)

**Milestones**: M4 (topic packages) ✅ · M5 (source-generated DI) ✅ · M6 (interactive generation) ✅

**Remaining unverified items**:

- [ ] Golden-file tests for generated code and AOT build validation
- [ ] Shared metadata model between Tera templates and Roslyn generators
- [ ] CI gates for empty project sets, unsupported patterns, and analyzer diagnostics

---

## Phase 3: Cross-Cutting Concerns, Logging, and API Routing

**Target window**: September-December 2026

**Goal**: Expand the compile-time foundation with cross-cutting concern abstractions (logging, mapping, caching, exception handling), API routing source generators, and OpenAPI integration.

**Full specification**: [specs/003-phase3-cross-cutting-logging-api/spec.md](../specs/003-phase3-cross-cutting-logging-api/spec.md)

**Milestones**: M7 (cross-cutting abstractions) · M8 (API route generation + OpenAPI) · M9 (integration tests)

**Resource estimate**: ~55-60 engineer-weeks

---

## Phase 4: Security Abstractions and Implementations

**Target window**: January-March 2027

**Goal**: Deliver security abstractions and first-party implementations (authentication, authorization, encryption) for securing NFramework services.

**Full specification**: [specs/004-phase4-security-abstractions/spec.md](../specs/004-phase4-security-abstractions/spec.md)

**Milestones**: M10 (security abstractions) · M11 (auth adapters) · M12 (encryption + secrets)

**Resource estimate**: ~30-35 engineer-weeks

---

## Phase 5: Diagnostic Analyzers

**Target window**: April-June 2027

**Goal**: Deliver Roslyn diagnostic analyzers for AOT compatibility checking, architecture validation, and compile-time enforcement of NFramework conventions.

**Full specification**: [specs/005-phase5-diagnostic-analyzers/spec.md](../specs/005-phase5-diagnostic-analyzers/spec.md)

**Milestones**: M13 (AOT analyzer) · M14 (architecture analyzer) · M15 (framework usage analyzer)

**Resource estimate**: ~20-25 engineer-weeks

---

## Phase 6: Beta Hardening and Public Beta

**Target window**: July-September 2027

**Goal**: Close the beta gate with documentation, KPI validation, release hardening, and a clear separation between beta-critical scope and beta-train follow-on items.

**Full specification**: [specs/006-phase6-beta-hardening/spec.md](../specs/006-phase6-beta-hardening/spec.md)

**Milestones**: M16 (documentation) · M17 (KPI validation) · M18 (public beta cut)

**Resource estimate**: ~30-34 engineer-weeks

---

## Phase 7: Distributed .NET Expansion

**Target window**: April-July 2027

**Goal**: Expand from standalone .NET services into distributed local development, observability defaults, and Dapr-backed platform adapters.

**Full specification**: [specs/007-phase7-distributed-dotnet/spec.md](../specs/007-phase7-distributed-dotnet/spec.md)

**Milestones**: M19 (Aspire generation) · M20 (Dapr adapters) · M21 (`nfw up` + guidance)

**Resource estimate**: ~45-50 engineer-weeks

---

## Phase 8: Interactive TUI Interface

**Target window**: October 2027-January 2028

**Goal**: Deliver an interactive TUI layer on top of the stable Rust CLI to provide visual workspace management, guided wizards, and real-time feedback.

**Full specification**: [specs/008-phase8-interactive-tui/spec.md](../specs/008-phase8-interactive-tui/spec.md)

**Milestones**: M22 (TUI architecture) · M23 (dashboard + wizard) · M24 (command palette)

**Resource estimate**: ~20-24 engineer-weeks

---

## Phase 9: Polyglot Standards and Ecosystem Tooling

**Target window**: February-July 2028

**Goal**: Extend the workspace standard beyond .NET, add contract sync, and make the CLI and workspace model consumable by MCP-compatible tooling.

**Full specification**: [specs/009-phase9-polyglot-ecosystem/spec.md](../specs/009-phase9-polyglot-ecosystem/spec.md)

**Milestones**: M25 (Go + Rust scaffolds) · M26 (Protobuf contract sync) · M27 (MCP-compatible surfaces)

**Resource estimate**: ~50-56 engineer-weeks

---

## Cross-Cutting Priorities

These priorities apply across all phases:

- [ ] Keep domain and application layers independent from implementation-specific libraries
- [ ] Keep the `.NET` service path coherent as abstractions, adapters, and generators expand
- [ ] Prefer framework abstractions plus adapters over direct library coupling
- [ ] Maintain Native AOT and trimming compatibility as product-level constraints
- [ ] Keep generated code readable, reviewable, and deterministic
- [ ] Keep build, test, and benchmark workflows simple and repeatable
- [ ] Use CI smoke tests and fixture-based generation tests as release blockers, not as optional quality improvements

## Remaining Planning Dependencies

The roadmap still depends on a small number of product-level decisions or clarifications:

- [ ] Resolve the command contract for CRUD generation between PRD section `7` (`US-003`) and section `11`
- [ ] Confirm whether localization, translation, mailing, and search ship in the first public beta or in beta follow-on releases within the same beta train
- [ ] Align the PRD technical consideration for CLI implementation language with the Rust CLI roadmap decision
- [ ] Lock the benchmark environment used for startup and generation KPI sign-off
- [ ] Define the minimum stable surface required before MCP-compatible tooling work begins

## Notes

- This roadmap is directional and should be updated whenever the PRD changes materially.
- If beta scope expands, the roadmap should be revised explicitly rather than allowing milestone drift.
- If staffing drops below the planning assumption, the first public beta should slip rather than weakening the compile-time, AOT, or clean architecture constraints.
