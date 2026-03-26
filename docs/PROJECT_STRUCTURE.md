# Project Structure

## Meta-Repo

```text
n-framework/
├── docs/                           # Product specs, PRD, roadmap
├── scripts/                        # Build, test, format, lint automation
├── src/
│   ├── nfw/                        # CLI tool (git submodule)
│   ├── n-framework-core-cli/       # CLI framework library (submodule)
│   ├── n-framework-core-template/  # Template engine library (submodule)
│   └── nfw-templates/              # Starter templates (submodule)
├── .editorconfig
├── LICENSE
├── Makefile
└── README.md
```

This repository orchestrates module repositories via git submodules. Module repos contain their own implementation specs; the meta-repo contains cross-module integration specs.

## nfw CLI (`src/nfw/`)

```text
src/nfw/
├── specs/                          # Module-level specifications
└── src/NFramework.NFW/
    ├── core/
    │   ├── NFramework.NFW.Domain/          # Entities, value objects, domain events
    │   └── NFramework.NFW.Application/     # CQRS handlers, application services
    ├── infrastructure/
    │   ├── NFramework.NFW.Infrastructure.FileSystem/
    │   └── NFramework.NFW.Infrastructure.GitHub/
    └── presentation/
        └── NFramework.NFW.CLI/             # Spectre.Console CLI commands
```

Each layer organizes code by feature under `Features/`:

- **Domain**: Value objects, entities, domain events per feature
- **Application**: Commands, queries, handlers, services per feature
- **Infrastructure**: Adapter implementations per feature
- **Presentation (CLI)**: Spectre.Console commands per feature

Example namespace pattern:

```
NFramework.NFW.Domain.Features.TemplateManagement.ValueObjects
NFramework.NFW.Application.Features.ProjectManagement.Commands.New
NFramework.NFW.CLI.Features.ProjectManagement.Commands.ListTemplates
```

## Clean Architecture Layers

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
