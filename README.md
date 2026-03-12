# NFramework

NFramework is a compile-time-first framework and workspace standard for building clean architecture microservices.

The product vision is a polyglot ecosystem across .NET, Go, and Rust. The first delivery focus is a .NET-first platform path centered on Native AOT compatibility, source-generated framework behavior, strong architecture boundaries, and cloud-native defaults.

## Status

This repository is currently in the planning and specification stage.

- The primary source of truth is [docs/PRD.md](docs/PRD.md).
- The framework, CLI, and adapters described below are planned capabilities, not yet a released implementation.
- The initial beta target is .NET-first.

## Why NFramework

Modern service teams often end up with:

- reflection-heavy runtime frameworks that work poorly with Native AOT
- clean architecture rules that exist in slides but are not enforced in code
- repeated scaffolding and boilerplate for every new service
- infrastructure concerns leaking into application and domain layers
- inconsistent project structure across teams and languages

NFramework is intended to solve that with one opinionated system:

- compile-time code generation instead of runtime discovery where practical
- strict layer boundaries
- explicit `Result<T>` style application flow
- replaceable infrastructure adapters
- CLI-driven scaffolding and validation
- cloud-native defaults through Aspire and Dapr

## Core Principles

### Compile-Time Magic

Dependency registration, route generation, and similar framework behavior should be generated at build time instead of discovered through runtime reflection.

### Pure Core

Domain and application layers should stay free of direct dependencies on EF Core, Dapr, messaging SDKs, or HTTP framework details.

### Explicit Outcomes

Business workflows should prefer explicit result types over exceptions for normal control flow.

### Replaceable Infrastructure

Persistence, messaging, cache, and cloud integrations should be implemented behind adapters so infrastructure choices can change without rewriting core logic.

### One Standard, Many Languages

The long-term goal is one workspace model and one architectural standard across .NET, Go, and Rust services.

## Planned Capabilities

### CLI

The planned `nfw` CLI is the main developer entry point.

Example planned commands:

```bash
nfw new my-workspace
nfw add service orders --lang dotnet
nfw add entity Product --props Name:string,Price:decimal
nfw check
nfw up
nfw sync
```

Planned responsibilities:

- create new workspaces
- scaffold services by language
- generate entity and CRUD flows
- validate architecture boundaries
- boot local development environments
- synchronize shared contracts in the polyglot phase

### .NET-first Beta Scope

The initial beta is expected to focus on:

- `NFramework.Domain` abstractions such as entities, aggregate roots, value objects, and domain events
- `NFramework.Application` abstractions such as CQRS contracts, validation flow, and result types
- source-generated DI registration
- source-generated Minimal API route mapping
- Wolverine integration for request handling and messaging
- EF Core and Dapper infrastructure adapters
- Aspire AppHost and ServiceDefaults generation
- Dapr adapters for pub/sub, state management, and secret store
- one-command build and one-command test workflows for generated solutions

### Polyglot Expansion

After the .NET reference path is proven, the platform is expected to expand with:

- Go service scaffolding
- Rust service scaffolding
- shared Protobuf contracts
- gRPC-first cross-service communication
- consistent workspace conventions across languages

## What Makes It Different

- Native AOT and trimming compatibility are treated as product requirements, not an afterthought.
- Minimal API is the preferred HTTP model for generated .NET services.
- Architectural enforcement is part of the product through generation and validation, not just documentation.
- Dapr and Aspire are first-class platform concerns in the intended developer workflow.

## Current Priorities

The documented roadmap is:

1. Foundations and .NET-first CLI
2. Code generation and infrastructure adapters
3. Cloud-native defaults and beta release
4. Polyglot expansion

See [docs/PRD.md](docs/PRD.md) for the detailed scope, acceptance criteria, and success metrics.

## License

This project is licensed under the [MIT License](LICENSE).
