# TestService

## Folder Layout

```text
core/
  TestService.Domain/
  TestService.Application/
infrastructure/
  TestService.Persistence/
presentation/
  TestService.WebApi/
```

Each folder holds the clean architecture layers with corresponding `*.csproj` files.

Models (configuration, DTO, and helper records) live under `Models` subfolders inside each layer.

## Layer Highlights

- `core/TestService.Domain`: Business entities and value objects.
- `core/TestService.Application`: Application services and DI registration helpers.
- `infrastructure/TestService.Infrastructure.Persistence`: Database context (`BaseDbContext`), EF Core setup, and configuration models (e.g., `DatabaseConfiguration`).
- `presentation/TestService.WebApi`: Host bootstrap (`Program.cs`), health endpoints, and OpenAPI configuration.

## Health Endpoints

- `GET /health/live`
- `GET /health/ready`

---

```text
   _  ______                                   __
  / |/ / __/______ ___ _  ___ _    _____  ____/ /__
 /    / _// __/ _ `/  ' \/ -_) |/|/ / _ \/ __/  '_/
/_/|_/_/ /_/  \_,_/_/_/_/\__/|__,__/\___/_/ /_/\_\
```

Generated from template [`dotnet-service`](https://github.com/n-framework/nfw-templates) of [NFramework](https://github.com/n-framework/).
