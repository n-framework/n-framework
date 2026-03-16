# N-Framework Specification Guidelines

## Purpose

This repo follows spec-driven development: write a testable spec first, then plan/design, then break work into executable tasks.
Specs exist to reduce ambiguity, keep architecture intentional, and make change reviewable.

## Repository Model (Meta-Repo + Submodules)

This repository is a meta-repo that orchestrates module repositories via git submodules (for example `src/nfw`).

- Module repositories contain their own implementation specs and detailed plans.
- The meta-repo contains orchestration specs that track cross-module integration and submodule pinning.

## Specification Types and Where They Live

### 1. Orchestrator Specs (meta-repo): `specs/<id>-<slug>/`

Purpose: track meta-repo work needed to consume changes from module repositories.

Typical contents:

- `specs/<id>-<slug>/spec.md`: what changes must land in submodules and what this meta-repo must do to consume them
- `specs/<id>-<slug>/plan.md`: high-level integration plan (submodule pinning, validation commands, release steps)
- `specs/<id>-<slug>/tasks.md`: short checklist of meta-repo tasks

Rule: orchestrator specs should avoid duplicating full module specs. Prefer linking to the canonical module spec.

### 2. Module Specs (within a module repo): `<module>/specs/<id>-<slug>/`

Purpose: define the module's behavior, architecture, contracts, and testable acceptance criteria.

Example:

- `src/nfw/specs/<id>-<slug>/` (lives in the `nfw` repository, checked out as a submodule here)

Rule: implementation decisions (project structure, commands, exit codes, interfaces) belong in the module spec, not in the meta-repo.

## Naming and Consistency Rules

- Spec directory name: `<id>-<slug>` where `<id>` is a 3-digit sequence (e.g., `001`) and `<slug>` is kebab-case.
- Avoid external project references inside specs. Specs should describe N-Framework behavior and constraints only.
- For .NET modules, keep project/folder naming consistent with the `NFramework.NFW.*` conventions (for example `NFramework.NFW.CLI`).

## What a Good Spec Contains

Minimum sections (module specs and orchestrator specs can be lighter or heavier, but must be testable):

- **Header metadata**: feature branch, spec type, project, status, input description
- User Scenarios & Testing: user stories with priorities, rationale, independent tests, and acceptance scenarios (Given/When/Then format)
- Requirements: functional requirements (FR-XXX numbered) and any key entities
- Success Criteria: measurable outcomes (SC-XXX numbered)
- Assumptions: what we're taking as given
- Dependencies: what this spec depends on
- Clarifications: Q&A from specification sessions (optional but recommended)
- Non-goals: explicit out-of-scope items
- Edge cases: invalid input, partial failures, offline modes, cancellation (Ctrl+C), etc.

## Template (Module Spec)

```markdown
# Feature Specification: <Title>

**Feature Branch**: `<id>-<slug>`
**Spec Type**: Project-Based
**Project**: <project-name>
**Created**: YYYY-MM-DD
**Status**: Draft | In Review | Approved | Implemented
**Input**: User description: "<one-line summary from user input>"

> **Note**: This spec is organized as project-based. See `.specify/SPEC_ORGANIZATION.md` for details on spec organization types.

## User Scenarios & Testing _(mandatory)_

### User Story 1 - <Title> (Priority: P1)

As a <user type>, I want to <action> so I can <benefit>.

**Why this priority**: <rationale for priority level>

**Independent Test**: <how this can be tested independently, what value it delivers>

**Acceptance Scenarios**:

1. **Given** <precondition>, **When** <action>, **Then** <expected outcome>
2. **Given** <precondition>, **When** <action>, **Then** <expected outcome>

---

### User Story 2 - <Title> (Priority: P2)

<same structure as User Story 1>

---

## Edge Cases

- **<Case name>**: <description of edge case behavior>
- **No arguments**: When <command> is run with no arguments...
- **Invalid command**: When an unknown command is entered...
- **Interrupt signal**: When the user sends Ctrl+C...

## Requirements _(mandatory)_

### Functional Requirements

- **FR-001**: <requirement text - MUST/SHOULD/MAY language>
- **FR-002**: <requirement text>
- **FR-003**: <requirement text>

### Key Entities

- **<Entity 1>**: <definition/description>
- **<Entity 2>**: <definition/description>

## Success Criteria _(mandatory)_

### Measurable Outcomes

- **SC-001**: <measurable outcome with numbers/timeframes>
- **SC-002**: <measurable outcome>
- **SC-003**: <measurable outcome>

## Assumptions

- <assumption 1>
- <assumption 2>
- <assumption 3>

## Dependencies

- <dependency 1>
- <dependency 2>

## Clarifications

### Session YYYY-MM-DD

- Q: <question>? → A: <answer>
- Q: <question>? → A: <answer>

### Session YYYY-MM-DD

- Q: <question>? → A: <answer>

## Non-Goals

- <non-goal 1>
- <non-goal 2>
- <non-goal 3>
```

## Writing Good User Stories

Each user story should include:

- **Priority level** (P1, P2, P3, etc.): P1 indicates the most critical user journeys
- **"Why this priority"**: Rationale explaining why this story has its assigned priority
- **"Independent Test"**: How this can be tested independently and what value it delivers
- **Acceptance Scenarios**: Given/When/Then format describing concrete test cases

### Priority Guidelines

- **P1**: Critical user journeys - without these, users cannot effectively use the feature
- **P2**: Important but not blocking - standard expectations that enable proper workflows
- **P3**: Nice-to-have or can be minimally implemented - can start empty or with basic functionality

### Given/When/Then Format

```
**Given** <precondition - the starting state>,
**When** <action - what the user does>,
**Then** <expected outcome - what should happen>
```

Example:

```
**Given** the nfw CLI is installed,
**When** I run `nfw --help`,
**Then** I see a help screen displaying available commands and usage information
```

## Numbering Requirements

Use consistent prefixes for numbered items:

- **FR-001, FR-002, ...**: Functional Requirements
- **SC-001, SC-002, ...**: Success Criteria
- **NFR-001, NFR-002, ...**: Non-Functional Requirements (if needed)

Use MUST/SHOULD/MAY language in requirements:

- **MUST**: Absolute requirement
- **SHOULD**: Recommended but may have valid reasons to bypass
- **MAY**: Optional feature

## Edge Cases to Consider

Common edge cases to address in specs:

- **No arguments**: Behavior when invoked without required inputs
- **Invalid input**: Handling of malformed or unexpected input
- **Missing configuration**: What happens when required config is absent
- **Permission errors**: Behavior without filesystem/network access
- **Network failures**: Offline mode or unreachable services
- **Interrupt signals**: Clean shutdown on Ctrl+C/SIGINT
- **Conflicting options**: When mutually exclusive flags are combined

## Workflow

1. Write or update the module spec in the module repo.
2. Implement via a PR against the module repo default branch.
3. Add/maintain an orchestrator spec in this meta-repo if the change requires submodule pinning or cross-module integration.
4. Update the submodule pointer in the meta-repo after the module PR is merged.
5. Verify using the acceptance criteria commands described in the orchestrator spec.
