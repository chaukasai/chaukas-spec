# Contributing to Chaukas Spec

Thank you for your interest in contributing to the Chaukas specification! This repository contains the Protocol Buffer definitions and generated client/server libraries for the Chaukas agent audit and explainability platform.

## Code of Conduct

This project adheres to the Contributor Covenant [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to 2153483+ranesidd@users.noreply.github.com.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the [issue tracker](https://github.com/chaukasai/chaukas-spec/issues) to avoid duplicates. When creating a bug report, include as many details as possible:

* **Use a clear and descriptive title**
* **Describe the exact steps to reproduce the problem**
* **Provide specific examples** (proto definitions, generated code issues, etc.)
* **Describe the behavior you observed and what you expected**
* **Include version information** (protoc version, buf version, Python/Go versions)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

* **Use a clear and descriptive title**
* **Provide a detailed description** of the suggested enhancement
* **Explain why this enhancement would be useful** to the community
* **Consider backward compatibility** implications for existing users

### Protocol Buffer Changes

Changes to `.proto` files are the most critical as they affect all downstream users:

1. **Breaking Changes**: Avoid breaking changes whenever possible. If necessary:
   - Discuss in an issue first
   - Follow [buf breaking change guidelines](https://docs.buf.build/breaking/overview)
   - Document migration path for users

2. **Non-Breaking Changes**: Safe additions include:
   - New optional fields
   - New RPC methods
   - New message types
   - New enum values (append only)

3. **Naming Conventions**:
   - Use `snake_case` for field names
   - Use `PascalCase` for message and service names
   - Use `SCREAMING_SNAKE_CASE` for enum values
   - Prefix enum values with the enum type name

### Pull Request Process

1. **Branch Naming**: Follow the branch naming convention:
   ```
   feature/description-here
   fix/description-here
   bugfix/description-here
   hotfix/description-here
   docs/description-here
   chore/description-here
   ```

2. **Before Submitting**:
   ```bash
   # Format proto files
   make format

   # Lint proto files
   make lint

   # Generate code
   make gen-all

   # Build and test packages
   make build-packages
   make test-packages
   ```

3. **Commit Messages**:
   - Use clear, descriptive commit messages
   - Start with a verb in imperative mood (e.g., "Add", "Fix", "Update")
   - Reference issue numbers when applicable

4. **Pull Request Description**:
   - Clearly describe what changes you're making and why
   - Reference any related issues
   - Include any breaking changes or migration notes
   - Add examples of how the changes work

5. **Code Review**:
   - Maintainers will review your PR
   - Address feedback promptly
   - Keep the PR focused on a single concern
   - Squash commits if requested

## Development Setup

### Prerequisites

* **buf** - Protocol buffer tooling ([installation guide](https://docs.buf.build/installation))
* **Go** 1.21+ for Go development
* **Python** 3.9+ for Python development
* **make** - Build automation

### Getting Started

```bash
# Clone the repository
git clone https://github.com/chaukasai/chaukas-spec.git
cd chaukas-spec

# Generate code
make gen-all

# Run linting
make lint

# Build packages
make build-packages

# Test packages
make test-packages
```

### Project Structure

```
proto/chaukas/spec/          # Source .proto files
├── common/v1/               # Shared data models
├── client/v1/               # Client-side service definitions
└── server/v1/               # Server-side service definitions

chaukas/spec/                # Generated Go code
python-client/               # Python client package
python-server/               # Python server package
.generated/python/           # Temporary Python generated code
```

## Style Guidelines

### Protocol Buffers

* Follow the [buf style guide](https://docs.buf.build/best-practices/style-guide)
* Use `buf format` to automatically format files
* Include comprehensive field documentation
* Keep backwards compatibility in mind

### Documentation

* Update README.md if adding new features or changing structure
* Document all public proto fields and services
* Include code examples for significant changes
* Update version numbers consistently across all files

## Version Management

When releasing a new version, update version numbers in:

* `python-client/pyproject.toml`
* `python-server/pyproject.toml`
* `resources/client-init.py`
* `resources/server-init.py`
* `openapi/chaukas/spec/v1/public.yaml`

## Release Process

Releases are automated via GitHub Actions:

1. Update version numbers in all required files
2. Create and push a version tag: `git tag v1.x.x && git push origin v1.x.x`
3. GitHub Actions automatically:
   - Builds packages
   - Runs tests
   - Publishes to PyPI (via Trusted Publishing)
   - Creates GitHub release
   - Updates Go module

## Questions?

If you have questions about contributing, feel free to:

* Open an issue with the `question` label
* Reach out to maintainers at 2153483+ranesidd@users.noreply.github.com

Thank you for contributing to Chaukas! 🎉
