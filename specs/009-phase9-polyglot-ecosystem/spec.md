# Feature Specification: Phase 9 - Polyglot Standards and Ecosystem Tooling

## Overview

This specification defines the extension of NFramework's workspace standard beyond .NET to support Go and Rust service scaffolding, Protobuf-driven contract synchronization, and the stable CLI/metadata surfaces required for MCP-compatible tooling. This phase delivers the long-term product vision of one architectural standard across languages.

## User Scenarios & Testing

### User Story 1 - Scaffold Go and Rust Services (Priority: P1)

As a platform engineer managing a polyglot ecosystem, I want to scaffold Go and Rust services using the same NFramework workspace model so that all services follow consistent architecture boundaries regardless of language.

**Why this priority**: Polyglot scaffolding is the primary deliverable of this phase. Without it, NFramework remains a .NET-only tool.

**Independent Test**: Can be fully tested by running `nfw add service --lang go` and `nfw add service --lang rust` and verifying the generated projects follow NFramework folder structure and boundary rules.

**Acceptance Scenarios**:

1. **Given** an existing NFramework workspace, **When** I run `nfw add service Orders --lang go`, **Then** a Go service is created with the NFramework layer structure
2. **Given** an existing NFramework workspace, **When** I run `nfw add service Payments --lang rust`, **Then** a Rust service is created with the NFramework layer structure
3. **Given** a polyglot workspace, **When** I run `nfw check`, **Then** architecture validation applies the same boundary rules to Go, Rust, and .NET services
4. **Given** a generated Go or Rust service, **When** I run the documented build command, **Then** the service compiles successfully

---

### User Story 2 - Synchronize Contracts Across Languages (Priority: P1)

As a developer working with multiple services, I want a single command to regenerate shared contracts so that API contracts stay in sync across all services regardless of language.

**Why this priority**: Contract drift between services in different languages is the most common source of integration failures in polyglot ecosystems.

**Independent Test**: Can be fully tested by modifying a Protobuf contract and running `nfw sync`, then verifying the generated code is updated in both .NET and Go services.

**Acceptance Scenarios**:

1. **Given** a shared Protobuf contract, **When** I run `nfw sync`, **Then** generated code is updated in all services that reference the contract
2. **Given** a Protobuf contract used by .NET and Go services, **When** I modify the contract and sync, **Then** both services have updated generated code that compiles
3. **Given** a contract sync, **When** generated artifact locations change, **Then** the sync command updates references deterministically

---

### User Story 3 - Expose Workspace Metadata for Tooling (Priority: P2)

As a tooling developer, I want stable workspace metadata and CLI surfaces so that I can build MCP-compatible tools and agents that interact with NFramework workspaces.

**Why this priority**: Tooling integration extends NFramework's value but is not required for core service development workflows.

**Independent Test**: Can be fully tested by querying workspace metadata and verifying it returns accurate service listings, language information, and available operations.

**Acceptance Scenarios**:

1. **Given** a workspace with multiple services, **When** a tool queries workspace metadata, **Then** it receives structured data listing services, languages, and available operations
2. **Given** stable CLI surfaces, **When** a tool invokes an `nfw` command programmatically, **Then** the output format is consistent and parseable
3. **Given** workspace metadata, **When** a new service is added, **Then** the metadata is updated automatically

---

### Edge Cases

- What happens when a Protobuf contract is referenced by a language without a protoc plugin? → `nfw sync` skips the unsupported language and emits a warning listing the missing plugin
- What happens when Go or Rust toolchains are not installed? → `nfw add service` detects the missing toolchain and provides installation instructions
- What happens when contract sync generates conflicting code? → The sync command fails with a merge conflict report and does not overwrite existing files

## Requirements

### Functional Requirements

#### Polyglot Scaffolding

- **FR-001**: The system MUST support `nfw add service --lang go` to generate Go services with NFramework layer structure
- **FR-002**: The system MUST support `nfw add service --lang rust` to generate Rust services with NFramework layer structure
- **FR-003**: The system MUST generate build, test, and runtime instructions for Go and Rust services
- **FR-004**: The system MUST apply the same architecture boundary rules to all supported languages via `nfw check`

#### Contract Synchronization

- **FR-005**: The system MUST support `nfw sync` for Protobuf-driven contract regeneration across supported languages
- **FR-006**: The system MUST support shared contract workflows across at least two supported languages
- **FR-007**: The system MUST generate Protobuf artifacts in deterministic, language-specific locations
- **FR-008**: The system MUST validate cross-language sample with one gRPC contract

#### Workspace Metadata and Tooling Surfaces

- **FR-009**: The system MUST expose stable workspace metadata (services, languages, operations) in a structured format
- **FR-010**: The system MUST provide CLI output formats suitable for programmatic consumption (JSON)
- **FR-011**: The system MUST document automation surfaces required for MCP-compatible tooling

### Key Entities

- **LanguageScaffold**: Template-based project structure for a specific language (Go, Rust) following NFramework conventions
- **ProtobufContract**: Shared API contract defined in `.proto` files with ownership, version, and consumer metadata
- **WorkspaceMetadata**: Structured data describing workspace contents, services, languages, and available operations

## Success Criteria

### Measurable Outcomes

- **SC-001**: Go and Rust services follow the same NFramework structure and boundary rules verified by `nfw check`
- **SC-002**: Shared contracts can be regenerated through `nfw sync` in a single documented workflow
- **SC-003**: At least two languages interoperate through the same Protobuf contract flow with zero manual code changes
- **SC-004**: Polyglot expansion does not weaken the .NET service path (all existing .NET tests continue to pass)

## Assumptions

- .NET conventions, folder structure, and contract placement are stable before polyglot scaffolding begins
- Protobuf ownership rules and generated artifact locations are deterministic
- Language-specific scaffolds preserve the same architectural expectations without forcing .NET implementation details into non-.NET services
- Go and Rust communities have mature Protobuf tooling (protoc-gen-go, tonic/prost for Rust)
- MCP-compatible tooling is a consumer of stable CLI and workspace contracts, not a driver of architectural changes

## Dependencies

- **Phases 1-7**: .NET conventions, folder structure, and CLI must be stable
- **Protobuf tooling**: Language-specific protoc plugins must be available
- **Go/Rust toolchains**: Must be installable on supported development platforms

## Non-Goals

- Deep runtime feature parity between Go/Rust and .NET (scaffold parity first)
- Implementing NFramework abstractions (mediator, persistence, etc.) in Go or Rust
- Building MCP servers or agents (only exposing stable surfaces for external tool builders)
- Supporting languages beyond Go and Rust in this phase
- Container orchestration or deployment automation for polyglot services
