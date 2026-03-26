# NFramework

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/n-framework/n-framework?style=social)](https://github.com/n-framework/n-framework/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/n-framework/n-framework?style=social)](https://github.com/n-framework/n-framework/network/members)
[![GitHub contributors](https://img.shields.io/github/contributors/n-framework/n-framework)](https://github.com/n-framework/n-framework/graphs/contributors)
[![GitHub issues](https://img.shields.io/github/issues/n-framework/n-framework)](https://github.com/n-framework/n-framework/issues)
[![Buy A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?logo=buy-me-a-coffee&logoColor=black&style=flat)](https://ahmetcetinkaya.me/donate)

A compile-time-first application framework and workspace standard for building **clean architecture services**. The first delivery focus is a .NET-first platform centered on Native AOT compatibility, source-generated framework behavior, and strong architecture boundaries.

---

## 📋 Status

This repository is currently in the **planning and specification stage**.

- The primary source of truth is [docs/PRD.md](docs/PRD.md).
- The framework, CLI, and adapters described below are planned capabilities, not yet a released implementation.
- The initial beta target is .NET-first.

---

## 🚀 Quick Start

### Installation

```bash
# Clone and initialize
git clone https://github.com/n-framework/n-framework.git
cd n-framework
make build

# Run the CLI
dotnet run --project src/nfw/src/NFramework.NFW/presentation/NFramework.NFW.CLI/NFramework.NFW.CLI.csproj -- templates
```

### Basic Usage

```bash
# List available templates
nfw templates

# Create a new workspace from a template
nfw new my-workspace

# Add a service scaffold
nfw add service orders --lang dotnet

# Validate architecture boundaries
nfw check
```

---

## 🛠 Contributing

For development setup, build/test commands, code style, and contribution guidelines, see **[docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)**.

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

## 📚 Documentation

- [PRD.md](docs/PRD.md) — Product requirements, user stories, acceptance criteria
- [ROADMAP.md](docs/ROADMAP.md) — Delivery planning and phase boundaries
- [PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md) — Repository layout and module organization
- [CONTRIBUTING.md](docs/CONTRIBUTING.md) — Development setup, build commands, and contribution guidelines
- [SPECIFICATION_GUIDELINES.md](docs/SPECIFICATION_GUIDELINES.md) — Spec-driven development workflow

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

## 🛠 Planned Capabilities

### CLI

The planned `nfw` CLI is the main developer entry point.

```bash
nfw templates                                          # List available templates
nfw new my-workspace                                   # Create from template
nfw add service orders --lang dotnet                   # Scaffold a service
nfw add entity Product --props Name:string,Price:decimal  # Generate entity
nfw add command ApproveOrder Orders                    # Generate command
nfw add query GetOrderByNumber Orders                  # Generate query
nfw check                                              # Validate architecture
nfw up                                                 # Boot local dev environment
nfw sync                                               # Sync shared contracts
```

### .NET-first Beta Scope

- Template-aware `nfw new`, `.NET` service scaffolding, and `nfw check`
- `NFramework.Domain` abstractions: entities, aggregate roots, value objects, domain events
- `NFramework.Application` abstractions: CQRS contracts, result types, business rules
- Source-generated DI registration and Minimal API route mapping
- Framework-native CQRS execution with commands, queries, events, and behaviors
- Security contracts for JWT, refresh tokens, operation claims, and authorization
- Topic-specific abstractions with optional library adapters

### Planned Post-Beta Scope

- Aspire AppHost and ServiceDefaults generation
- Dapr adapters for pub/sub, state management, and secret store
- Go and Rust service scaffolding
- Shared Protobuf contracts with gRPC cross-service communication

---

## ✨ What Makes It Different

- Native AOT and trimming compatibility are treated as product requirements, not an afterthought.
- Architectural enforcement is part of the product through generation and validation, not just documentation.
- The framework combines first-party abstractions, generators, and adapters in one opinionated system.
- Dapr and Aspire are first-class platform concerns in the long-term developer workflow.

---

## 📄 License

This project is licensed under the **Apache License 2.0** - see the [LICENSE](LICENSE) file for details.
