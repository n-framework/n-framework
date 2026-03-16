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

Purpose: define the module’s behavior, architecture, contracts, and testable acceptance criteria.

Example:

- `src/nfw/specs/<id>-<slug>/` (lives in the `nfw` repository, checked out as a submodule here)

Rule: implementation decisions (project structure, commands, exit codes, interfaces) belong in the module spec, not in the meta-repo.

## Naming and Consistency Rules

- Spec directory name: `<id>-<slug>` where `<id>` is a 3-digit sequence (e.g., `001`) and `<slug>` is kebab-case.
- Avoid external project references inside specs. Specs should describe N-Framework behavior and constraints only.
- For .NET modules, keep project/folder naming consistent with the `NFramework.NFW.*` conventions (for example `NFramework.NFW.CLI`).

## What a Good Spec Contains

Minimum sections (module specs and orchestrator specs can be lighter or heavier, but must be testable):

- Context: why we are doing this and what it changes
- Goals and non-goals (explicit out-of-scope)
- Functional requirements: behaviors, inputs/outputs, CLI UX, error handling
- Non-functional requirements: measurable targets (avoid vague words like "fast" or "robust" without numbers)
- Edge cases: invalid input, partial failures, offline modes, cancellation (Ctrl+C), etc.
- Acceptance criteria: how we verify the feature is complete (commands/tests/exit codes)

## Template (Module Spec)

```markdown
# <id>-<slug>

## Context

## Goals

## Non-Goals

## Functional Requirements

## Non-Functional Requirements

## Edge Cases

## Acceptance Criteria
```

## Workflow

1. Write or update the module spec in the module repo.
2. Implement via a PR against the module repo default branch.
3. Add/maintain an orchestrator spec in this meta-repo if the change requires submodule pinning or cross-module integration.
4. Update the submodule pointer in the meta-repo after the module PR is merged.
5. Verify using the acceptance criteria commands described in the orchestrator spec.
