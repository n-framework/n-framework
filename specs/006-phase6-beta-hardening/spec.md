# Feature Specification: Phase 6 - Beta Hardening and Public Beta

## Overview

This specification defines the documentation, KPI validation, release hardening, and scope management required to close the beta gate and deliver the first public NFramework beta. This phase converts engineering completeness into product readiness.

## User Scenarios & Testing

### User Story 1 - Follow Quickstart to Running Service (Priority: P1)

As a new NFramework adopter, I want a quickstart guide that takes me from zero to a running service so that I can evaluate the framework without reverse-engineering generated code.

**Why this priority**: Onboarding experience is the primary factor in framework adoption. Without documentation, even technically excellent frameworks fail to attract users.

**Independent Test**: Can be fully tested by having a developer with no NFramework experience follow the quickstart guide on a clean machine and verifying they can create a workspace, generate a service, and run a CRUD workflow within 30 minutes.

**Acceptance Scenarios**:

1. **Given** a clean development environment with .NET 11 and nfw CLI installed, **When** a developer follows the quickstart guide, **Then** they can create a workspace, add a service, generate a CRUD entity, and run the service with working endpoints
2. **Given** the quickstart guide, **When** a developer encounters an error during any step, **Then** the troubleshooting section addresses the error with resolution steps
3. **Given** a completed quickstart, **When** a developer wants to add a second entity, **Then** the guide links to relevant command documentation

---

### User Story 2 - Validate Performance KPIs (Priority: P1)

As a release manager, I want automated benchmark reporting so that I can verify the framework meets performance targets before the public beta release.

**Why this priority**: Performance is a core product promise (AOT compatibility, fast startup, fast generation). Unverified performance claims undermine credibility.

**Independent Test**: Can be fully tested by running the benchmark harness and verifying all KPI targets are met on the baseline hardware configuration.

**Acceptance Scenarios**:

1. **Given** the benchmark harness, **When** workspace creation is benchmarked, **Then** it completes in less than 1 second on baseline hardware
2. **Given** the benchmark harness, **When** CRUD generation is benchmarked, **Then** it completes in less than 10 seconds
3. **Given** a generated service, **When** cold start is benchmarked, **Then** it starts in less than 50 ms under agreed benchmark conditions
4. **Given** a generated service, **When** Native AOT publish is executed, **Then** zero trimming or AOT warnings are emitted

---

### User Story 3 - Understand Architecture Decisions (Priority: P2)

As a tech lead, I want architecture documentation that explains layer responsibilities and forbidden dependencies so that my team can follow NFramework conventions correctly.

**Why this priority**: Architecture guidance prevents teams from introducing violations that would be caught by `nfw check` or analyzers, reducing friction during adoption.

**Independent Test**: Can be fully tested by having a tech lead read the architecture guide and correctly identify which layers can reference which dependencies, without consulting source code.

**Acceptance Scenarios**:

1. **Given** the architecture documentation, **When** a tech lead reads the layer responsibilities section, **Then** they can list the allowed and forbidden dependencies for each layer
2. **Given** the architecture documentation, **When** a developer introduces a violation, **Then** the documentation explains why the dependency is forbidden and how to restructure

---

### Edge Cases

- What happens when a generated service has different behavior on Windows vs Linux? → The documentation documents platform-specific differences and the CI validates both platforms
- What happens when .NET 11 preview introduces breaking changes? → The release checklist includes .NET SDK version pinning and regression testing
- What happens when benchmark results vary between hardware configurations? → KPI targets are defined for the agreed baseline hardware; results on other hardware are informational only

## Requirements

### Functional Requirements

#### Documentation

- **FR-001**: The system MUST provide a quickstart guide covering workspace creation, service addition, entity generation, CRUD workflow, and running the service
- **FR-002**: The system MUST provide architecture documentation covering layer responsibilities, forbidden dependencies, and namespace conventions
- **FR-003**: The system MUST provide command reference documentation for all `nfw` CLI commands with examples
- **FR-004**: The system MUST provide troubleshooting guidance for common generator, configuration, and setup failures
- **FR-005**: The system MUST provide extension point documentation for adding custom templates, adapters, and pipeline behaviors

#### Performance Validation

- **FR-006**: The system MUST provide continuous benchmark reporting for workspace creation time, CRUD generation time, and cold start
- **FR-007**: The system MUST validate that generated services build with zero Native AOT or trimming warnings
- **FR-008**: The system MUST verify that workspace creation completes in less than 1 second on baseline hardware
- **FR-009**: The system MUST verify that CRUD generation completes in less than 10 seconds
- **FR-010**: The system MUST verify that cold start is less than 50 ms under agreed benchmark conditions

#### Release Hardening

- **FR-011**: The system MUST provide release checklists for AOT, trimming, smoke tests, and CI reproducibility
- **FR-012**: The system MUST validate that generated starter solutions build and test successfully in CI without manual patch steps
- **FR-013**: The system MUST provide a beta follow-on packaging plan for lower-priority adapters (localization, mailing, search)

### Key Entities

- **BenchmarkResult**: Performance measurement with metric name, value, unit, baseline hardware specification, and pass/fail status against KPI target
- **ReleaseChecklist**: Ordered list of validation steps required before beta release, with pass/fail status per item

## Success Criteria

### Measurable Outcomes

- **SC-001**: A new NFramework adopter can follow the quickstart guide and have a running service within 30 minutes on a clean machine
- **SC-002**: Generated hello-world .NET service builds with zero Native AOT or trimming warnings
- **SC-003**: Generated standard .NET service cold-starts in less than 50 ms under agreed benchmark conditions
- **SC-004**: Generating a standard CRUD flow takes less than 10 seconds
- **SC-005**: Creating a new workspace completes in less than 1 second on baseline hardware
- **SC-006**: Generated starter solutions build and test successfully in CI without manual patch steps

## Assumptions

- Core .NET beta workflows (Phases 1-5) are functional end-to-end before beta hardening begins
- Benchmark environment and baseline hardware are finalized before KPI sign-off
- Public command syntax and template conventions are frozen through the beta cut
- Beta scope is anchored to PRD section 12 metrics, not to an expanding adapter wish list
- Technical writing support (0.5 FTE) is available starting in this phase

## Dependencies

- **Phases 1-5**: All core .NET framework features must be stable
- **Benchmark environment**: Must be finalized before KPI sign-off
- **CLI stability**: Public command syntax must be frozen before documentation is written

## Non-Goals

- Expanding beta scope beyond the PRD section 12 metrics
- Implementing localization, translation, mailing, or search adapters (beta follow-on)
- Creating video tutorials or interactive learning content
- Supporting older .NET versions (only .NET 11 target)
