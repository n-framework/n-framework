# Feature Specification: Phase 8 - Interactive TUI Interface

## Overview

This specification defines the interactive TUI (Terminal User Interface) layer on top of the stable Rust CLI. The TUI provides visual workspace management, guided wizards, and real-time feedback for common workflows. This phase is deferred until after all .NET expansion phases are stable, ensuring the TUI wraps a production-ready foundation.

## User Scenarios & Testing

### User Story 1 - Create Workspace via Guided Wizard (Priority: P1)

As a developer new to NFramework, I want a step-by-step visual wizard for workspace creation so that I can discover available options without memorizing CLI flags.

**Why this priority**: The guided wizard is the primary TUI value proposition — it lowers the barrier for teams who prefer visual, interactive workflows over memorizing CLI commands.

**Independent Test**: Can be fully tested by launching the TUI, navigating the workspace creation wizard, and verifying the created workspace is identical to one created via the equivalent CLI command.

**Acceptance Scenarios**:

1. **Given** the TUI is launched, **When** I select "Create Workspace", **Then** a step-by-step wizard guides me through workspace name, template selection, and configuration options
2. **Given** the TUI wizard, **When** I complete all steps and confirm, **Then** the workspace is created with the same result as running the equivalent CLI command
3. **Given** the TUI wizard, **When** I press Escape at any step, **Then** the wizard is cancelled without creating partial files

---

### User Story 2 - View Workspace Dashboard (Priority: P1)

As a developer, I want a visual dashboard showing my workspace status so that I can see service health, recent operations, and quick-action shortcuts at a glance.

**Why this priority**: The dashboard provides the ongoing-use value of the TUI, keeping developers informed about workspace state without running multiple CLI commands.

**Independent Test**: Can be fully tested by opening the TUI in a workspace with services and verifying the dashboard displays service names, health indicators, and available actions.

**Acceptance Scenarios**:

1. **Given** a workspace with services, **When** I open the TUI dashboard, **Then** I see service names, health indicators, and recent operation history
2. **Given** the dashboard, **When** I select a service, **Then** I see detailed status and available actions (check, generate, etc.)
3. **Given** the dashboard, **When** a service has architecture violations, **Then** a warning indicator is displayed

---

### User Story 3 - Use Command Palette (Priority: P2)

As a power user, I want a fuzzy-search command palette so that I can quickly execute any NFramework command without navigating menus.

**Why this priority**: The command palette serves power users who want TUI convenience with CLI speed. It enhances productivity but is not required for basic TUI usage.

**Independent Test**: Can be fully tested by opening the command palette, typing a partial command name, and verifying the matching commands are displayed and executable.

**Acceptance Scenarios**:

1. **Given** the TUI is open, **When** I press the command palette shortcut, **Then** a fuzzy-search input appears with all available commands
2. **Given** the command palette, **When** I type "gen crud", **Then** matching commands are filtered and I can select one to execute
3. **Given** the command palette, **When** I execute a command, **Then** the result is displayed in the TUI with the same output as the CLI equivalent

---

### Edge Cases

- What happens when the terminal is too small to render the TUI? → A minimum terminal size is enforced; if the terminal is smaller, a message instructs the user to resize
- What happens when the TUI is run in a non-interactive terminal (e.g., CI)? → The TUI exits with an error message suggesting the CLI alternative
- What happens when a TUI action fails? → The error is displayed inline with the same error message as the CLI equivalent, plus a "retry" option

## Requirements

### Functional Requirements

#### TUI Architecture

- **FR-001**: The TUI MUST wrap existing CLI commands without duplicating business logic
- **FR-002**: All TUI workflows MUST remain available through the CLI for CI and scripting
- **FR-003**: The TUI MUST be an optional layer; CLI remains the primary interface
- **FR-004**: The TUI MUST run on macOS, Linux, and Windows terminal emulators

#### Workspace Dashboard

- **FR-005**: The TUI MUST display service names, health indicators, and recent operation history
- **FR-006**: The TUI MUST provide quick-action shortcuts for common operations (check, generate, build)
- **FR-007**: The TUI MUST update dashboard state when workspace contents change

#### Wizards and Forms

- **FR-008**: The TUI MUST provide a step-by-step wizard for workspace creation
- **FR-009**: The TUI MUST provide a wizard for service creation with template preview
- **FR-010**: The TUI MUST provide form-based configuration editing with validation feedback

#### Command Palette

- **FR-011**: The TUI MUST provide a fuzzy-search command palette with all available CLI commands
- **FR-012**: The TUI MUST support keyboard shortcuts for common actions
- **FR-013**: The TUI MUST display command history and contextual help

### Key Entities

- **Dashboard**: Main TUI view showing workspace overview, service status, and action shortcuts
- **Wizard**: Multi-step guided workflow for complex operations (workspace creation, service creation)
- **CommandPalette**: Fuzzy-search overlay for discovering and executing CLI commands

## Success Criteria

### Measurable Outcomes

- **SC-001**: TUI can create a workspace, scaffold a service, and run architecture validation through guided workflows
- **SC-002**: All TUI actions produce identical results to their CLI equivalents
- **SC-003**: TUI runs on macOS, Linux, and Windows terminal emulators without rendering issues
- **SC-004**: New users can complete workspace creation via the TUI wizard without consulting external documentation

## Assumptions

- All core CLI commands (Phases 1-7) have stable, documented behavior contracts
- The .NET framework beta is stable with distributed features (Phase 7) fully validated
- Rust TUI libraries (ratatui or similar) are mature enough for production use
- Terminal emulator diversity (iTerm2, Windows Terminal, GNOME Terminal, etc.) is tested

## Dependencies

- **Phases 1-7**: All CLI commands must have stable behavior contracts
- **Phase 7**: Distributed .NET features must be fully validated before TUI wraps them

## Non-Goals

- Web-based UI (terminal-only)
- IDE extensions or plugins (use existing CLI integration)
- Real-time collaboration features
- Replacing the CLI as the primary interface
