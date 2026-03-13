# NFramework

![GitHub stars](https://img.shields.io/github/stars/n-framework/n-framework?style=social)
![GitHub forks](https://img.shields.io/github/forks/n-framework/n-framework?style=social)

NFramework is a compile-time-first framework and workspace standard for building clean architecture services.

The product vision is a polyglot ecosystem across .NET, Go, and Rust. The first delivery focus is a .NET-first platform path centered on Native AOT compatibility, source-generated framework behavior, and strong architecture boundaries.

---

## 📋 Status

This repository is currently in the planning and specification stage.

- The primary source of truth is [docs/PRD.md](docs/PRD.md).
- The framework, CLI, and adapters described below are planned capabilities, not yet a released implementation.
- The initial beta target is .NET-first.

---

## ❓ Why NFramework

Modern service teams often end up with:

- Reflection-heavy runtime frameworks that work poorly with Native AOT
- Clean architecture rules that exist in slides but are not enforced in code
- Repeated scaffolding and boilerplate for every new service
- Infrastructure concerns leaking into application and domain layers
- Inconsistent project structure across teams and languages

NFramework is intended to solve that with one opinionated system:

- Compile-time code generation instead of runtime discovery where practical
- Strict layer boundaries
- Explicit `Result<T>` style application flow
- Topic-specific abstractions with replaceable infrastructure adapters
- CLI-driven scaffolding and validation
- Cloud-native defaults through Aspire and Dapr after the standalone .NET path is stable

---

## 💡 Core Principles

### Compile-Time Magic

Dependency registration, route generation, and similar framework behavior should be generated at build time instead of discovered through runtime reflection.

### Pure Core

Domain and application layers should stay free of direct dependencies on persistence libraries, Dapr, messaging SDKs, or HTTP framework details.

### Explicit Outcomes

Business workflows should prefer explicit result types over exceptions for normal control flow.

### Replaceable Infrastructure

NFramework should define abstractions per topic, such as persistence, messaging, caching, or secrets. The codebase should depend on those abstractions, while popular libraries and providers are integrated through adapters behind them.

### One Standard, Many Languages

The long-term goal is one workspace model and one architectural standard across .NET, Go, and Rust services.

---

## 🚀 Planned Capabilities

### CLI

The planned `nfw` CLI is the main developer entry point.

Example planned commands:

```bash
nfw templates
nfw new my-workspace
nfw add service orders --lang dotnet
nfw add entity Product --props Name:string,Price:decimal
nfw add command ApproveOrder Orders
nfw add query GetOrderByNumber Orders
nfw check
nfw up
nfw sync
```

Planned responsibilities:

- List and select starter templates
- Create new workspaces
- Scaffold services by language
- Generate entities, CRUD flows, standalone commands, and standalone queries
- Support interactive and non-interactive generation workflows
- Carry feature options such as caching, logging, transaction, security, and API exposure through generation
- Validate architecture boundaries
- Boot local development environments
- Synchronize shared contracts in the polyglot phase

### .NET-first Beta Scope

The initial beta is expected to focus on:

- Template-aware `nfw new`, `.NET` service scaffolding, and `nfw check`
- `nfw add entity`, `nfw add command`, and `nfw add query`
- .NET service scaffolding
- `NFramework.Domain` abstractions such as entities, aggregate roots, value objects, and domain events
- `NFramework.Application` abstractions such as CQRS contracts, result types, business rules, pageable requests, and pipeline markers
- Framework-native CQRS execution with commands, queries, events, stream requests, and behaviors
- Abstract repository contracts with paging, dynamic query support, bulk operations, and migration hooks
- Security contracts for JWT, refresh tokens, operation claims, authorization, and multi-channel authenticators
- Framework abstractions plus initial adapters for validation, mapping, logging, problem details, localization, translation, mailing, SMS, and search
- Source-generated DI registration
- Source-generated Minimal API route mapping
- Topic-specific abstractions used throughout the codebase, with optional library adapters behind infrastructure boundaries
- One-command build and one-command test workflows for generated solutions

### Planned Post-Beta Scope

After the .NET service path is proven, the platform is expected to expand with:

- Additional `.NET` integration packs
- Aspire AppHost and ServiceDefaults generation
- Dapr adapters for pub/sub, state management, and secret store
- Local orchestration for distributed service development
- Go service scaffolding
- Rust service scaffolding
- Shared Protobuf contracts
- Cross-service communication via gRPC
- Consistent workspace conventions across languages

---

## ✨ What Makes It Different

- Native AOT and trimming compatibility are treated as product requirements, not an afterthought.
- Minimal API is the preferred HTTP model for generated .NET services.
- Architectural enforcement is part of the product through generation and validation, not just documentation.
- The framework combines first-party abstractions, generators, and adapters in one opinionated system.
- Dapr and Aspire are first-class platform concerns in the long-term developer workflow, but they come after the standalone `.NET` service path.

---

## 🎯 Current Priorities

The documented roadmap is:

1. Foundations and core contracts
2. Generator and `.NET` service beta
3. Post-beta `.NET` integrations and distributed features
4. Polyglot expansion

See [docs/PRD.md](docs/PRD.md) for the detailed scope, acceptance criteria, and success metrics.

---

## ⚖️ License

This project is licensed under the [MIT License](LICENSE).
