# Chaukas Specification

Canonical proto3 schemas for Chaukas — immutable AI-agent audit events, traces/spans, tool calls, and governance decisions (OTEL-friendly).

## Overview

Chaukas is the Governance, Compliance, Safety, Trust and Explainability layer for AI agents and applications. This repository defines the source-of-truth Protobuf messages used to capture every event and decision into an append-only, WORM-retained audit trail with deep queryability and OpenTelemetry compatibility. This repository contains:

- **Protocol Buffer definitions** for event schema and gRPC services
- **Generated Python client libraries** for SDK integration
- **Generated Go server libraries** for platform implementation

## Structure

```
proto/chaukas/spec/
├── common/v1/       # Shared data models (Event, QueryRequest, etc.)
├── client/v1/       # Client-side gRPC service definitions  
└── server/v1/       # Server-side gRPC service definitions

python-client/       # Client SDK package (chaukas-spec-client)
python-server/       # Server implementation package (chaukas-spec-server)

chaukas/spec/        # Generated Go packages and module
├── common/v1/       # Data models
├── client/v1/       # Client gRPC stubs
└── server/v1/       # Server gRPC stubs + server-specific models

.generated/python/   # Temporary generated Python code (build artifact)
```

## Installation

### For Client-side SDK Development
```bash
pip install chaukas-spec-client
```

### For Server-side Platform Implementation
```bash
pip install chaukas-spec-server
```

### For Go Development
```bash
go get github.com/chaukasai/chaukas-spec
```

## Python Usage

### SDK Integration (Client-side)
```python
from chaukas.spec.client.v1.client_pb2_grpc import ChaukasClientServiceStub
from chaukas.spec.client.v1.client_pb2 import IngestEventRequest
from chaukas.spec.common.v1.events_pb2 import Event, EventType

# Create gRPC client
stub = ChaukasClientServiceStub(channel)

# Create and send event
event = Event(
    event_id="evt_123",
    type=EventType.EVENT_TYPE_AGENT_START,
    session_id="session_abc"
)
request = IngestEventRequest(event=event)
stub.IngestEvent(request)
```

### Platform Implementation (Server-side)
```python
from chaukas.spec.server.v1.server_pb2_grpc import ChaukasServerServiceServicer
from chaukas.spec.server.v1.server_pb2 import IngestEventResponse

class MyChaukasServer(ChaukasServerServiceServicer):
    def IngestEvent(self, request, context):
        # request is IngestEventRequest with .event field
        return IngestEventResponse(
            event_id=request.event.event_id,
            status="accepted"
        )
```

## Go Usage (Server-side)

```go
import (
    serverv1 "github.com/chaukasai/chaukas-spec/chaukas/spec/server/v1"
)

type MyChaukasServer struct {
    serverv1.UnimplementedChaukasServerServiceServer
}

func (s *MyChaukasServer) IngestEvent(ctx context.Context, req *serverv1.IngestEventRequest) (*serverv1.IngestEventResponse, error) {
    return &serverv1.IngestEventResponse{
        EventId: req.Event.EventId,
        Status: "accepted",
    }, nil
}
```

## Development

### Generate Code
```bash
make gen-all        # Generate both Python and Go code
make gen-python     # Generate Python code only (for packages)
make gen-go         # Generate Go code only
```

### Build Packages
```bash
make build-packages # Build both client and server Python packages
make build-client   # Build client package only
make build-server   # Build server package only
```

### Test Packages
```bash
make test-packages  # Test both packages can be installed and imported
```

### Clean Generated Code
```bash
make clean-all      # Clean all generated code
make clean-python   # Clean Python code only
make clean-go       # Clean Go code only
make clean-packages # Clean built packages
```

### Lint and Format
```bash
make lint           # Lint proto files with buf
make format         # Format proto files with buf
make breaking       # Check for breaking changes against main
```

## CI/CD Pipeline

[![CI](https://github.com/chaukasai/chaukas-spec/workflows/CI/badge.svg)](https://github.com/chaukasai/chaukas-spec/actions)

The repository includes a comprehensive CI/CD pipeline that:

1. **🔍 Lints & Validates**: Runs `buf lint` and format checking
2. **🚨 Breaking Changes**: Detects API breaking changes on PRs
3. **🔨 Build & Test**: Generates code and tests compilation across multiple Python/Go versions
4. **📦 Package Building**: Creates separate client and server Python packages
5. **🚀 Automated Releases**: Publishes to PyPI and Go modules on version tags

### Release Process

**Automated via PyPI Trusted Publishing:**
1. Update version in package files:
   - `python-client/pyproject.toml`
   - `python-server/pyproject.toml` 
   - `resources/client-init.py`
   - `resources/server-init.py`
   - `openapi/chaukas/spec/v1/public.yaml`
2. Create and push a version tag: `git tag v1.0.3 && git push origin v1.0.3`
3. GitHub Actions automatically builds and publishes packages using PyPI Trusted Publishing

**Requirements:**
- GitHub environments `pypi-client` and `pypi-server` configured
- PyPI Trusted Publishing enabled for both packages

## Architecture

The specification supports comprehensive agent observability through:

- **Comprehensive Event Types**: 
  - Session lifecycle: SESSION_START, SESSION_END
  - Agent operations: AGENT_START, AGENT_END, AGENT_HANDOFF
  - Model invocations: MODEL_INVOCATION_START, MODEL_INVOCATION_END  
  - Tool interactions: TOOL_CALL_START, TOOL_CALL_END
  - Protocol calls: MCP_CALL_START, MCP_CALL_END
  - I/O events: INPUT_RECEIVED, OUTPUT_EMITTED
  - Error handling: ERROR, RETRY
- **Distributed Tracing**: Full trace correlation with trace_id field across all events
- **Agent Handoff Tracking**: Complete agent-to-agent transition monitoring with context
- **MCP Integration**: Native Model Context Protocol call tracking and observability
- **Enhanced Tool Tracking**: Granular function-level tracking within tools
- **Span-based Architecture**: Parent-child relationships for complex agent workflows
- **Rich Metadata**: Performance metrics, cost tracking, infrastructure data
- **Audit Features**: WORM compliance, content hashing, integrity proofs  
- **Privacy**: PII categorization, redaction capabilities
- **Multi-tenancy**: Tenant and project scoping

This is part of the open-core Chaukas agent audit and explainability platform.
