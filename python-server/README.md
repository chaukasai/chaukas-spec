# Chaukas Spec Server

**Protocol buffers and gRPC service definitions for building Chaukas-compatible observability backends**

[![PyPI version](https://badge.fury.io/py/chaukas-spec-server.svg)](https://badge.fury.io/py/chaukas-spec-server)
[![Python 3.9+](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## What is this?

`chaukas-spec-server` provides the server-side Protocol Buffer definitions and gRPC service interfaces for the [Chaukas](https://github.com/chaukasai/chaukas-spec) agent observability platform. Use this package to:

- **Build observability backends** that comply with the Chaukas specification
- **Implement gRPC services** for ingesting agent telemetry
- **Process and store** 19+ standardized event types
- **Provide analytics** on agent performance and behavior
- **Enable compliance** with audit trail requirements

## Who should use this?

- **Platform engineers** building observability and monitoring platforms
- **Backend developers** implementing telemetry collection services
- **DevOps teams** deploying agent monitoring infrastructure
- **Security teams** building compliance and audit systems

> **Note:** If you're instrumenting an agent or SDK to send events, use [`chaukas-spec-client`](https://pypi.org/project/chaukas-spec-client/) instead.

## Installation

```bash
pip install chaukas-spec-server
```

## Quick Start

```python
from concurrent import futures
import grpc
from chaukas.spec.server.v1.server_pb2_grpc import (
    ChaukasServerServiceServicer,
    add_ChaukasServerServiceServicer_to_server
)
from chaukas.spec.server.v1.server_pb2 import IngestEventResponse

class MyChaukasServer(ChaukasServerServiceServicer):
    def IngestEvent(self, request, context):
        # Process the event
        event = request.event
        print(f"Received event: {event.event_id} of type {event.type}")

        # Store in your database, send to analytics, etc.
        # ...

        # Return response with processing details
        return IngestEventResponse(
            event_id=event.event_id,
            status="accepted",
            processed_at=int(time.time() * 1000)
        )

# Start gRPC server
server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
add_ChaukasServerServiceServicer_to_server(MyChaukasServer(), server)
server.add_insecure_port('[::]:50051')
server.start()
server.wait_for_termination()
```

## Server-Specific Features

The server package includes additional capabilities beyond the client package:

### Enhanced Response Types
- **IngestEventResponse** - Detailed ingestion status with timestamps
- **IngestEventBatchResponse** - Batch processing results with accept/reject counts
- **GetEventStatsResponse** - Analytics and statistics on event data

### Additional RPC Methods
- **GetEventStats** - Retrieve aggregated statistics by tenant, project, or time range

### Event Analytics
```python
def GetEventStats(self, request, context):
    # Return aggregated metrics
    return GetEventStatsResponse(
        total_events=1000,
        total_sessions=50,
        events_by_type={
            "EVENT_TYPE_AGENT_START": 50,
            "EVENT_TYPE_MODEL_INVOCATION_START": 300,
        },
        avg_session_duration_ms=45000.0
    )
```

## Event Types

Handle comprehensive event types for complete agent observability:

| Category | Event Types |
|----------|-------------|
| **Session** | SESSION_START, SESSION_END |
| **Agent** | AGENT_START, AGENT_END, AGENT_HANDOFF |
| **Model** | MODEL_INVOCATION_START, MODEL_INVOCATION_END |
| **Tools** | TOOL_CALL_START, TOOL_CALL_END, MCP_CALL_START, MCP_CALL_END |
| **I/O** | INPUT_RECEIVED, OUTPUT_EMITTED |
| **Errors** | ERROR, RETRY |
| **Extensions** | POLICY_DECISION, DATA_ACCESS, STATE_UPDATE, SYSTEM |

## Package Contents

```
chaukas/spec/
├── server/v1/       # Server gRPC service interfaces
│   ├── server_pb2.py
│   └── server_pb2_grpc.py
└── common/v1/       # Shared event definitions
    ├── events_pb2.py
    └── query_pb2.py
```

## Architecture Considerations

When building your observability backend:

- **Storage**: Design for high-volume event ingestion (consider time-series databases)
- **Multi-tenancy**: Use tenant_id and project_id fields for isolation
- **Analytics**: Pre-aggregate statistics for common queries
- **Compliance**: Implement WORM (Write-Once-Read-Many) for audit trails
- **Privacy**: Respect PII categorization and redaction fields
- **Performance**: Use batch ingestion for high-throughput scenarios

## Documentation

- **Full Specification**: [chaukas-spec repository](https://github.com/chaukasai/chaukas-spec)
- **Protocol Definitions**: [proto/chaukas/spec/](https://github.com/chaukasai/chaukas-spec/tree/main/proto/chaukas/spec)
- **Architecture**: See [main README](https://github.com/chaukasai/chaukas-spec#architecture)
- **Examples**: [Usage examples](https://github.com/chaukasai/chaukas-spec#python-usage)

## Related Packages

- **[chaukas-spec-client](https://pypi.org/project/chaukas-spec-client/)** - Client-side SDK for sending events
- **[chaukas-sdk](https://pypi.org/project/chaukas-sdk/)** - One-line instrumentation for popular agent frameworks

## Contributing

We welcome contributions! Please see our [Contributing Guide](https://github.com/chaukasai/chaukas-spec/blob/main/CONTRIBUTING.md) and [Code of Conduct](https://github.com/chaukasai/chaukas-spec/blob/main/CODE_OF_CONDUCT.md).

## License

Apache 2.0 - See [LICENSE](https://github.com/chaukasai/chaukas-spec/blob/main/LICENSE) for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/chaukasai/chaukas-spec/issues)
- **Discussions**: [GitHub Discussions](https://github.com/chaukasai/chaukas-spec/discussions)
- **Security**: See [SECURITY.md](https://github.com/chaukasai/chaukas-spec/blob/main/SECURITY.md)
