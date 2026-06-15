.PHONY: help setup format lint test build clean

help:
	@echo "Available targets:"
	@echo "  make setup   - Restore dotnet tools"
	@echo "  make format  - Format code using dotnet format and csharpier"
	@echo "  make lint    - Run strict linting and analysis"
	@echo "  make test    - Run tests"
	@echo "  make build   - Build the solution"
	@echo "  make clean   - Clean build artifacts"
	@echo "  make help    - Show this help message"

setup:
	@echo "🔧 Restoring dotnet tools..."
	dotnet tool restore

format:
	@echo "🔧 Fixing code style violations (dotnet format)..."
	-dotnet format whitespace TestService.slnx
	-dotnet format style TestService.slnx --severity warn
	-dotnet format analyzers TestService.slnx --severity warn
	@echo "🎨 Formatting with CSharpier..."
	-dotnet csharpier format .
	@echo "✅ Formatting complete!"

lint:
	@echo "🔍 Verifying code style with dotnet format..."
	dotnet format TestService.slnx style --verify-no-changes
	@echo "🔍 Running strict C# analyzers with dotnet build..."
	dotnet build TestService.slnx -warnaserror:true -verbosity:normal \
		-p:EnforceCodeStyleInBuild=true \
		-p:EnableCodeStyleSeverity=warning \
		-p:EnableNETAnalyzers=true \
		-p:AnalysisMode=All \
		-p:AnalysisLevel=latest
	@echo "✨ Linting complete!"

test:
	@echo "🧪 Running .NET tests..."
	dotnet test TestService.slnx -m:1 -nodeReuse:false
	@echo "✅ Test run complete!"

build:
	@echo "🔨 Building .NET solution..."
	dotnet build TestService.slnx
	@echo "✨ Build complete!"

clean:
	@echo "🧹 Cleaning build artifacts..."
	dotnet clean TestService.slnx
	@echo "✨ Clean complete!"
