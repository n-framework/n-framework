# Contributing

Thank you for your interest in contributing to NFramework.

## Prerequisites

- .NET 11 (preview)
- C# 12+

## Getting Started

```bash
git clone https://github.com/n-framework/n-framework.git
cd n-framework
```

All commands auto-initialize submodules and restore .NET tools.

## Development Commands

```bash
make build     # or ./scripts/build.sh   — build the entire solution
make test      # or ./scripts/test.sh    — run the full test suite
make format    # or ./scripts/format.sh  — format C# and config files
make lint      # or ./scripts/lint.sh    — static analysis and style checks
make deps      # or ./scripts/deps.sh    — check for outdated dependencies
```

## Running the CLI

```bash
dotnet run --project src/nfw/src/NFramework.NFW/presentation/NFramework.NFW.CLI/NFramework.NFW.CLI.csproj -- templates
dotnet run --project src/nfw/src/NFramework.NFW/presentation/NFramework.NFW.CLI/NFramework.NFW.CLI.csproj -- new sample --template blank
```

## Architecture

NFramework follows clean architecture with feature-based organization:

```
core/
├── NFramework.NFW.Domain/        # Domain entities, value objects, domain events
└── NFramework.NFW.Application/   # CQRS handlers, application services, workflows

infrastructure/
├── NFramework.NFW.Infrastructure.FileSystem/   # File system operations
└── NFramework.NFW.Infrastructure.GitHub/       # GitHub API interactions

presentation/
└── NFramework.NFW.CLI/         # Spectre.Console CLI commands
```

Each layer organizes code by feature under `Features/`.

## Key Rules

- **Pure Core**: Domain and Application layers must not depend on infrastructure libraries
- **Compile-Time Generation**: Use source generators instead of runtime reflection
- **Explicit Outcomes**: Use `Result<T>` pattern instead of exceptions for expected failures
- **Feature-Based Structure**: Organize code by feature, not by layer type

## Code Style

- File-scoped namespaces, LF line endings, 4-space indentation
- PascalCase for types and public members, `_camelCase` for private fields
- Explicit types (no `var`), `sealed` classes by default
- Format with CSharpier (`make format`), lint with Roslynator (`make lint`)

## Testing

- Framework: xUnit with Shouldly assertions
- Test naming: `Method_Scenario_ExpectedBehavior`
- CLI tests that interact with console: `[Collection("Cli command tests")]`
- Run tests: `make test`

## Specifications

This repo follows spec-driven development. See [SPECIFICATION_GUIDELINES.md](SPECIFICATION_GUIDELINES.md) for the full workflow.

Specs live in:

- Meta-repo: `docs/`
- Module specs: `src/nfw/specs/<id>-<slug>/`

## License

Contributions are licensed under the Apache License 2.0. See [LICENSE](../LICENSE).
