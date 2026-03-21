# Tasks: Phase 1 Foundations and Core Contracts

**Spec Type**: Monorepo
**Project**: N/A
**Input**: Project-spec topics from [`specs/001-phase1-foundations-core-contracts/`](./)
**Prerequisites**: plan.md, spec.md

**Tests**: Not included here. This task list only defines which Initial project-level spec topics should be created next.

**Organization**: Tasks are grouped by user story. Each task includes the exact spec input text to use for creating that project-level spec topic.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different projects or independent spec topics)
- **[Story]**: Which user story this task belongs to (e.g. US1, US2, US3, US4)
- Every task includes an exact file path

## Setup (Project Spec Scaffolding)

**Purpose**: Create the first project-level Initial spec topics that establish the CLI/workspace entry flow.

- [x] T000 Create CLI skeleton baseline spec topic in `src/nfw/specs/001-nfw-cli-skeleton/spec.md` with input: `CLI skeleton baseline: help, version, templates listing - The foundational CLI capabilities that this workspace and scaffolding spec builds upon.`
- [ ] T001 Create the template catalog and selection spec topic in `src/nfw/specs/002-template-catalog-and-selection/spec.md` with input: `Define template catalog listing and deterministic template selection for nfw, including stable template identifiers, interactive selection when a terminal is interactive, and explicit template selection for non-interactive usage.`
- [ ] T002 [P] Create the workspace creation spec topic in `src/nfw/specs/003-workspace-creation/spec.md` with input: `Define nfw workspace creation for standalone services, including workspace naming rules, target directory validation, generated root documentation, and one documented build command plus one documented test command.`

---

## Foundational (Blocking Spec Topics)

**Purpose**: Create the shared foundational spec topics that block all later project implementation planning.

**⚠️ CRITICAL**: No project implementation planning should begin until these spec topics exist.

- [ ] T003 Create the single-step build and test entrypoints spec topic in `src/nfw/specs/004-build-test-entrypoints/spec.md` with input: `Define the repository-root and generated-workspace build and test entrypoints so both build and full test suite run with one command from the root.`
- [ ] T004 [P] Create the domain primitives spec topic in `src/NFramework.Domain/specs/001-domain-primitives/spec.md` with input: `Define the shared NFramework.Domain primitives for standalone services, including Entity<TId>, AggregateRoot, ValueObject, and DomainEvent, with no infrastructure dependencies.`
- [ ] T005 [P] Create the application result model spec topic in `src/NFramework.Application/specs/001-results/spec.md` with input: `Define the shared NFramework.Application explicit outcome model, including Result and Result<T>, for normal application flow without infrastructure dependencies.`
- [ ] T006 [P] Create the application command/query contracts spec topic in `src/NFramework.Application/specs/002-command-query-contracts/spec.md` with input: `Define the shared NFramework.Application baseline contracts ICommand<TResponse> and IQuery<TResponse> for standalone service workflows without advanced dispatch or generation features.`

**Checkpoint**: Foundational Initial project specs exist and downstream project planning can start.

---

## User Story 1 - Create a workspace from a known template (Priority: P1) 🎯 MVP

**Goal**: Ensure the `src/nfw` project has the Initial topics needed for template-driven workspace creation.

**Independent Test**: Review the `src/nfw` specs and confirm they cover template listing, interactive/non-interactive selection, workspace creation, and generated workspace documentation.

- [ ] T007 [US1] Create the generated workspace documentation spec topic in `src/nfw/specs/005-generated-workspace-docs/spec.md` with input: `Define the generated workspace documentation for standalone services, including root quickstart guidance, build/test usage, and the minimum onboarding information a new team member needs after workspace creation.`

**Checkpoint**: `src/nfw` has the minimum Initial spec topics required to support workspace creation.

---

## User Story 2 - Scaffold a standalone service (Priority: P1)

**Goal**: Ensure the `src/nfw` project has the Initial topics needed for standalone service scaffolding.

**Independent Test**: Review the `src/nfw` specs and confirm they cover `add service`, the standalone service template, and the starter health/readiness baseline.

- [ ] T008 [US2] Create the add-service CLI spec topic in `src/nfw/specs/006-add-service-cli/spec.md` with input: `Define nfw add service for the standalone service path, including service naming rules, supported language validation, duplicate service protection, and generated output expectations.`
- [ ] T009 [P] [US2] Create the standalone service template spec topic in `src/nfw/specs/007-standalone-service-template/spec.md` with input: `Define the standalone service template generated by nfw add service, including Domain, Application, Infrastructure, and Api layers, starter assets, and shared framework contract references.`
- [ ] T010 [P] [US2] Create the health/readiness baseline spec topic in `src/nfw/specs/008-health-readiness-baseline/spec.md` with input: `Define the starter health or readiness baseline included in each generated standalone service so a fresh scaffold has a first-run verification endpoint.`

**Checkpoint**: `src/nfw` has the minimum Initial spec topics required to support standalone service scaffolding.

---

## User Story 3 - Build on shared core contracts (Priority: P2)

**Goal**: Ensure the shared contract projects have the Initial topics needed for reusable domain and application foundations.

**Independent Test**: Review the `src/NFramework.Domain` and `src/NFramework.Application` specs and confirm they cover domain primitives, explicit results, and baseline command/query contracts without infrastructure coupling.

- [ ] T011 [US3] Create the infrastructure-free dependency rules spec topic in `src/NFramework.Application/specs/003-infrastructure-free-contract-rules/spec.md` with input: `Define the dependency rules for shared application contracts so NFramework.Application remains free of infrastructure-specific dependencies and generated services keep Domain and Application clean.`

**Checkpoint**: The shared contract projects have the minimum Initial spec topics required for reusable framework contracts.

---

## User Story 4 - Understand and preserve baseline boundaries (Priority: P2)

**Goal**: Ensure the `src/nfw` project has the Initial topics needed to make layer boundaries explicit and reviewable.

**Independent Test**: Review the `src/nfw` specs and confirm they cover generated workspace boundary guidance and generated-workspace smoke validation.

- [ ] T012 [US4] Create the layer boundary guidance spec topic in `src/nfw/specs/009-layer-boundary-guidance/spec.md` with input: `Define the layer boundary guidance for generated standalone services, including allowed dependency direction, forbidden references, and where developers should place domain, application, infrastructure, and api code.`
- [ ] T013 [P] [US4] Create the generated-workspace smoke validation spec topic in `src/nfw/specs/010-generated-workspace-smoke-validation/spec.md` with input: `Define the generated-workspace smoke validation for standalone services, including first-run build verification, first-run test verification, and boundary rule validation for generated outputs.`

**Checkpoint**: `src/nfw` has the minimum Initial spec topics required to document and validate layer boundaries.

---

## Polish & Cross-Cutting Concerns

**Purpose**: Create the remaining cross-cutting project spec topics needed to complete the Initial project-spec set.

- [ ] T014 [P] Create the CLI stdout/stderr and exit-code extension spec topic in `src/nfw/specs/011-cli-stdout-stderr-exit-codes/spec.md` with input: `extend the nfw CLI surface rules for new and add service so normal output stays on stdout, diagnostics stay on stderr, and exit codes remain stable and documented for success, usage errors, runtime failures, and interruption.`
- [ ] T015 [P] Create the interruption and cleanup behavior spec topic in `src/nfw/specs/012-interruption-and-cleanup/spec.md` with input: `Define interruption handling and cleanup behavior for workspace and service generation so users are not left with ambiguous partial results after cancellation or failure.`
- [ ] T016 Create the generated quickstart and onboarding validation spec topic in `src/nfw/specs/013-quickstart-validation/spec.md` with input: `Define generated quickstart and onboarding validation for standalone services so a first-time user can follow the generated documentation to create a workspace, add a service, build it, and run tests successfully.`

---

## Dependencies & Execution Order

### Section Dependencies

- **Setup** starts immediately.
- **Foundational** depends on Setup and blocks all user story sections.
- **User Story 1** depends on Foundational.
- **User Story 2** depends on Foundational.
- **User Story 3** depends on Foundational.
- **User Story 4** depends on User Stories 1, 2, and 3 because it completes the boundary-review topics across the generated workspace flow.
- **Polish** depends on the desired user story sections being defined.

### User Story Dependencies

- **US1**: Depends on the setup and foundational project spec topics in `src/nfw`.
- **US2**: Depends on the foundational project spec topics plus the workspace flow topics from US1.
- **US3**: Depends on the foundational shared-contract spec topics in `src/NFramework.Domain` and `src/NFramework.Application`.
- **US4**: Depends on the workspace and service-scaffolding topics from US1 and US2 plus the shared-contract topics from US3.

### Suggested Completion Order

1. Setup
2. Foundational
3. US1 (MVP)
4. US2 and US3 in parallel when staffing allows
5. US4
6. Polish

---

## Parallel Opportunities

- **Setup**: T001 and T002 can run in parallel.
- **Foundational**: T004, T005, and T006 can run in parallel across different projects.
- **US2**: T009 and T010 can run in parallel.
- **US4**: T012 and T013 can run in parallel.
- **Polish**: T014 and T015 can run in parallel.

---

## Parallel Example: User Story 2

```bash
Task: "Create the standalone service template spec topic in src/nfw/specs/007-standalone-service-template/spec.md"
Task: "Create the health/readiness baseline spec topic in src/nfw/specs/008-health-readiness-baseline/spec.md"
```

## Parallel Example: User Story 3

```bash
Task: "Create the domain primitives spec topic in src/NFramework.Domain/specs/001-domain-primitives/spec.md"
Task: "Create the application result model spec topic in src/NFramework.Application/specs/001-results/spec.md"
Task: "Create the application command/query contracts spec topic in src/NFramework.Application/specs/002-command-query-contracts/spec.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Create the setup spec topics in `src/nfw`
2. Create the foundational shared-contract spec topics
3. Create the US1 generated-workspace documentation topic
4. Stop and review the resulting project-spec map before adding more Initial topics

### Incremental Delivery

1. Define the shared foundational Initial topics
2. Define the `src/nfw` workspace-creation topics
3. Define the `src/nfw` standalone-service topics
4. Define the shared-contract rules topic
5. Define the boundary and validation topics
6. Define the remaining cross-cutting Initial topics

### Parallel Team Strategy

1. One developer defines the `src/nfw` Initial CLI/workspace topics
2. One developer defines the `src/NFramework.Domain` Initial domain topic
3. One developer defines the `src/NFramework.Application` Initial application topics
4. Merge the topic set back into the root Initial orchestrator flow

---

## Notes

- This task list intentionally excludes implementation work and tracks only which project-level spec topics should exist for Phase 1.
- The existing `src/nfw` CLI skeleton, `templates` command, help/version behavior, and `src/nfw/Makefile` workflow are treated as already implemented baseline and therefore are not repeated as implementation tasks here.
- User Story 1 remains the suggested MVP because it defines the minimum project-spec set needed to open the Initial workflow.
