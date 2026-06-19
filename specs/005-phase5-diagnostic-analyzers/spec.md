# Feature Specification: Phase 5 - Diagnostic Analyzers

## Overview

This specification defines the Roslyn diagnostic analyzers for AOT compatibility checking, architecture validation, and compile-time enforcement of NFramework conventions. These analyzers provide developer-friendly compile-time diagnostics that catch architecture violations, AOT incompatibilities, and framework usage errors before runtime.

## User Scenarios & Testing

### User Story 1 - Detect AOT Incompatibilities at Compile Time (Priority: P1)

As a developer, I want the compiler to warn me when I use patterns that break Native AOT compatibility so that I catch issues during development instead of at deployment time.

**Why this priority**: AOT compatibility is a core product constraint. Runtime failures due to reflection or dynamic types are expensive to debug and undermine the framework's compile-time-first promise.

**Independent Test**: Can be fully tested by writing code that uses reflection (e.g., `GetType().GetMethods()`) and verifying a compiler diagnostic is emitted with a descriptive message and suggested fix.

**Acceptance Scenarios**:

1. **Given** code using `Type.GetMethods()` in a NFramework project, **When** the project compiles, **Then** diagnostic NFW1001 is emitted with message "Avoid runtime reflection; use source-generated alternatives"
2. **Given** code using `dynamic` keyword, **When** the project compiles, **Then** diagnostic NFW1002 is emitted identifying the dynamic type usage
3. **Given** code using `Activator.CreateInstance`, **When** the project compiles, **Then** diagnostic NFW1003 is emitted with a suggested alternative

---

### User Story 2 - Detect Architecture Violations in IDE (Priority: P1)

As a developer, I want real-time architecture violation feedback in my IDE so that I don't have to wait for `nfw check` to run to discover layer boundary violations.

**Why this priority**: IDE-integrated diagnostics provide immediate feedback, reducing the time between introducing a violation and discovering it. This complements the existing `nfw check` CLI command.

**Independent Test**: Can be fully tested by adding a forbidden reference (e.g., EF Core in the Domain layer) and verifying a squiggly diagnostic appears in the IDE without running any external command.

**Acceptance Scenarios**:

1. **Given** a Domain layer project referencing `Microsoft.EntityFrameworkCore`, **When** the project is opened in Visual Studio or VS Code, **Then** diagnostic NFW2001 is displayed on the using statement
2. **Given** an Application layer project referencing an Infrastructure namespace, **When** code is edited, **Then** diagnostic NFW2002 is emitted identifying the forbidden dependency
3. **Given** a clean project with no violations, **When** the project compiles, **Then** zero NFW2xxx diagnostics are emitted

---

### User Story 3 - Validate Framework Usage Patterns (Priority: P2)

As a developer, I want compile-time validation of NFramework-specific patterns so that common mistakes (missing registrations, incorrect naming) are caught automatically.

**Why this priority**: Framework usage errors are common for new adopters. Compile-time detection reduces onboarding friction, but services can function without these checks through manual code review.

**Independent Test**: Can be fully tested by creating a handler that doesn't follow naming conventions and verifying a diagnostic warning is emitted.

**Acceptance Scenarios**:

1. **Given** a command handler without a corresponding DI registration, **When** the project compiles, **Then** diagnostic NFW3001 is emitted suggesting the handler may not be discoverable
2. **Given** a command class not following naming conventions, **When** the project compiles, **Then** diagnostic NFW3002 is emitted as an informational suggestion
3. **Given** a repository interface without an implementation, **When** the project compiles, **Then** diagnostic NFW3003 is emitted identifying the unimplemented repository

---

### Edge Cases

- What happens when analyzers are installed but the project is not an NFramework project? → Analyzers are silently inactive; no diagnostics are emitted for non-NFramework projects
- What happens when analyzer diagnostics conflict with user-configured suppressions? → Standard `#pragma warning disable` and `.editorconfig` suppressions are respected
- What happens when an analyzer encounters generated code (`.g.cs` files)? → Generated code is excluded from analysis by default unless explicitly opted in

## Requirements

### Functional Requirements

#### AOT Compatibility Analyzer

- **FR-001**: The analyzer MUST detect runtime reflection usage (`GetType()`, `GetMethods()`, `GetProperties()`, etc.)
- **FR-002**: The analyzer MUST detect `dynamic` type and `ExpandoObject` usage
- **FR-003**: The analyzer MUST detect `Activator.CreateInstance` and similar instantiation patterns
- **FR-004**: The analyzer MUST detect serialization attributes incompatible with AOT
- **FR-005**: The analyzer MUST provide code fixes or suggested alternatives for detected patterns

#### Architecture Validation Analyzer

- **FR-006**: The analyzer MUST detect Domain layer dependencies on Infrastructure namespaces or packages
- **FR-007**: The analyzer MUST detect Application layer dependencies on presentation or framework-specific types
- **FR-008**: The analyzer MUST detect direct HTTP or database access from Domain or Application layers
- **FR-009**: The analyzer MUST detect forbidden namespace references based on configurable rules

#### Framework Usage Analyzer

- **FR-010**: The analyzer MUST detect missing handler registrations
- **FR-011**: The analyzer MUST detect improper command/query naming convention violations
- **FR-012**: The analyzer MUST detect missing repository interface implementations
- **FR-013**: The analyzer MUST detect incorrect attribute usage on handlers and entities

#### Package and Configuration

- **FR-014**: The system MUST package all analyzers in a single `NFramework.Analyzers` NuGet package
- **FR-015**: The system MUST support configurable diagnostic severities (error, warning, info) via `.editorconfig`
- **FR-016**: The system MUST exclude generated code (`.g.cs` files) from analysis by default
- **FR-017**: The system MUST integrate with `nfw check` CLI command for non-IDE validation workflows

### Key Entities

- **Diagnostic**: Compiler message with severity, code (NFWxxxx), message, location (file:line), and optional code fix
- **AnalyzerRule**: Configurable rule defining what pattern to detect, diagnostic severity, and suppression behavior
- **CodeFix**: Suggested code transformation that resolves a diagnostic violation

## Success Criteria

### Measurable Outcomes

- **SC-001**: AOT incompatibility diagnostics catch reflection, dynamic types, and unsafe instantiation patterns with zero false positives in NFramework test fixtures
- **SC-002**: Architecture violation diagnostics appear in Visual Studio and VS Code within the standard IDE refresh cycle
- **SC-003**: Developers can opt in to the analyzer package with a single NuGet reference
- **SC-004**: All analyzer diagnostics include actionable error messages with file and line locations
- **SC-005**: Unit tests validate every diagnostic rule using Roslyn analyzer test infrastructure

## Assumptions

- Phase 2 compile-time application model and source generators are stable
- Phase 3 cross-cutting concerns and API routing patterns are defined and stable
- Phase 4 security abstractions are finalized
- Roslyn analyzer infrastructure (`DiagnosticAnalyzer`, `CodeFixProvider`) is the implementation mechanism
- Generated `.g.cs` files from Phase 2 source generators are exempt from analysis by default
- Diagnostic codes follow the pattern NFWxxxx where the first digit indicates the category (1=AOT, 2=Architecture, 3=Usage)

## Dependencies

- **Phase 2**: Compile-time application model and source generators must be stable
- **Phase 3**: Cross-cutting concerns and API routing must be defined
- **Phase 4**: Security abstractions must be finalized
- **`nfw check`**: Integration with existing CLI architecture validation command

## Non-Goals

- Runtime analysis or profiling
- Performance optimization suggestions
- Code style enforcement (use existing .NET analyzers)
- Supporting non-C# languages
- Auto-fixing all detected violations (code fixes only for common patterns)
