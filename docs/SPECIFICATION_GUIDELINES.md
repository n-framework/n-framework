# N-Framework Specification Guidelines

## Purpose

This repo follows spec-driven development: write a testable spec first, then plan the orchestrator view, then break work into the next required specification topics.
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
- `specs/<id>-<slug>/plan.md`: high-level orchestration plan (module split, validation expectations, downstream spec map)
- `specs/<id>-<slug>/tasks.md`: short checklist of which project-level spec topics must exist next

Rule: orchestrator specs should avoid duplicating full module specs. Prefer linking to or naming the canonical module spec topics.

Additional rule for orchestrator `tasks.md`: it should define the downstream project spec topics and the spec instruction text to use for those specs. It should not expand into project implementation tasks.

### 2. Module Specs (within a module repo): `<module>/specs/<id>-<slug>/`

Purpose: define the module's behavior, architecture, contracts, and testable acceptance criteria.

Example:

- `src/nfw/specs/<id>-<slug>/` (lives in the `nfw` repository, checked out as a submodule here)

Rule: implementation decisions (project structure, commands, exit codes, interfaces) belong in the module spec, not in the meta-repo.

## Naming and Consistency Rules

- Spec directory name: `<id>-<slug>` where `<id>` is a 3-digit sequence (e.g., `001`) and `<slug>` is kebab-case.
- **Use descriptive slugs**: Name specs by what they deliver (e.g., `workspace-scaffolding`, `cli-skeleton`) rather than phase numbers (avoid `phase1-*`).
- Avoid external project references inside specs. Specs should describe N-Framework behavior and constraints only.
- For .NET modules, keep project/folder naming consistent with the `NFramework.NFW.*` conventions (for example `NFramework.NFW.CLI`).

## What a Good Spec Contains

Minimum sections (module specs and orchestrator specs can be lighter or heavier, but must be testable):

- User Scenarios & Testing: user stories with priorities, rationale, independent tests, and acceptance scenarios (Given/When/Then format)
- Requirements: functional requirements (FR-XXX numbered) and any key entities
- Success Criteria: measurable outcomes (SC-XXX numbered)
- Assumptions: what we're taking as given
- Dependencies: what this spec depends on
- Clarifications: Q&A from specification sessions (optional but recommended)
- Non-goals: explicit out-of-scope items
- Edge cases: invalid input, partial failures, offline modes, cancellation (Ctrl+C), etc.

### Spec Writing Rules

Specs should read like natural human writing. Avoid tool-generated markers and framework-specific keywords, for example:

- Do not include `_(mandatory)_` annotations on section headers.
- Do not include `**Feature Branch**`, `**Spec Type**`, `**Project**`, `**Created**`, `**Status**`, or `**Spec Instruction**` metadata headers.
- Do not reference `.specify/` paths or external spec tooling (e.g., `.specify/SPEC_ORGANIZATION.md`).
- Do not include `> **Note**: This spec is organized as...` disclaimers.
- Under `## Clarifications`, list Q&A items directly. Do not add `### Session YYYY-MM-DD` sub-headings.
- Do not reference tool commands like `/speckit.clarify`, `/speckit.plan`, `/speckit.tasks`.

In module `tasks.md`, keep task organization markers — they are useful for planning:

- `[P]` marks tasks that can run in parallel (different files, no blocking dependencies).
- `[US1]` through `[US5]` mark which user story a task belongs to.
- These should NOT be removed when cleaning specs.

For orchestrator specs, keep the artifact set minimal unless a stronger need exists:

- `spec.md`
- `plan.md`
- `tasks.md`

Do not create extra design documents such as `research.md`, `data-model.md`, `contracts/`, or `quickstart.md` unless the orchestrator spec truly needs them to coordinate multiple module repositories. The default is to keep root specs lean and push detail into the module specs.

## Template (Module Spec)

```markdown
# Feature Specification: <Title>

## User Scenarios & Testing

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

## Requirements

### Functional Requirements

- **FR-001**: <requirement text - MUST/SHOULD/MAY language>
- **FR-002**: <requirement text>
- **FR-003**: <requirement text>

### Key Entities

- **<Entity 1>**: <definition/description>
- **<Entity 2>**: <definition/description>

## Success Criteria

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

- Q: <question>? → A: <answer>
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

```**Given** <precondition - the starting state>,
**When** <action - what the user does>,
**Then** <expected outcome - what should happen>
```

Example:

```**Given** the nfw CLI is installed,
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

1. Write or update the orchestrator spec in this meta-repo when the change spans multiple module repositories or needs root-level coordination.
2. Use the orchestrator `tasks.md` to define which project-level spec topics must be created next and include the exact spec instruction text for each one.
3. Create those project-level specs in the relevant module repositories on feature branches (do not commit specs directly to the default branch).
4. Implement via PRs against the module repo default branches.
5. Update the submodule pointers in the meta-repo after the module PRs are merged.
6. Verify using the acceptance criteria and validation steps described in the orchestrator spec.

## Orchestrator Task Writing

When writing `specs/<id>-<slug>/tasks.md` for a meta-repo spec:

- **Organize tasks by feature**, not by milestone. Group related work (e.g., template metadata schema + `nfw templates` command) into a single feature entry. Each feature produces one spec in its most natural location.
- Fold cross-cutting concerns (CLI routing, command parsing) into the feature that first needs them, rather than creating a separate spec.
- Each task should identify the target project spec path.
- Each task should include the exact spec instruction text that should be used to create that project-level spec.
- **Task format**: Use the pattern `- [ ] F#-T### <action> spec topic in <path> with spec instruction: <spec instruction text>` for consistency, where `F#` is the feature number and `T###` is the task number within that feature.
- Include a `_Maps to:_` line tracing back to original milestone tasks when reorganizing from a milestone-based plan.
- Include a `_Status:_` line when a spec already partially exists.
- Do not write project implementation tasks in the root orchestrator `tasks.md`.
- Do not restate code-level file edits, tests, or service registrations there; those belong in the downstream project specs and their own planning artifacts.

### Example Feature-Based Task Structure

```markdown
## F1 — Template System

### F1-T001

- [ ] Create spec topic in `src/nfw/specs/` with spec instruction: Define the template metadata schema, template repository format, git-based template discovery, template versioning rules, and the `nfw templates` command that lists available starter templates with identifiers, descriptions, and git repository URLs, supporting both local and remote template repositories.

_Status_: Partially exists as `src/nfw/specs/001-nfw-template-system/` — review and extend if needed.

_Maps to_: M1-T001, M2-T005
```
