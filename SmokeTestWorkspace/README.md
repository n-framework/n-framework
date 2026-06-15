# SmokeTestWorkspace

## Folder Layout

```text
src/
```

The `src/` directory is your starting point. Add your project files, modules, or subdirectories here as your workspace grows.

## Getting Started

1. Add your source files under `src/`
2. Create subdirectories to organize your code by feature, layer, or module
3. Update this README as your project structure evolves

## Adding Services

Use `nfw add service` to generate services from templates:

```bash
# Add a service interactively
nfw add service

# Add a service with a specific name
nfw add service MyService

# Add a service from a specific template
nfw add service MyService --template dotnet-service

# Skip interactive prompts
nfw add service MyService --template dotnet-service --no-input
```

List available templates:

```bash
nfw templates list
```

## Workspace Guidelines

- Keep related files grouped logically within `src/`
- Add a `.gitkeep` to any empty directories you want tracked by Git
- Maintain consistent naming conventions across your workspace

---

```text
   _  ______                                   __
  / |/ / __/______ ___ _  ___ _    _____  ____/ /__
 /    / _// __/ _ `/  ' \/ -_) |/|/ / _ \/ __/  '_/
/_/|_/_/ /_/  \_,_/_/_/_/\__/|__,__/\___/_/ /_/\_\
```

Generated from template [`blank-workspace`](https://github.com/n-framework/nfw-templates) of [NFramework](https://github.com/n-framework/).
