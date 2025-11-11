# Chaukas Spec Client

**Protocol buffers and gRPC stubs for integrating Chaukas agent observability into your SDKs**

[![PyPI version](https://badge.fury.io/py/chaukas-spec-client.svg)](https://badge.fury.io/py/chaukas-spec-client)
[![Python 3.9+](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## What is this?

`chaukas-spec-client` provides the client-side Protocol Buffer definitions and gRPC service stubs for the [Chaukas](https://github.com/chaukasai/chaukas-spec) agent observability platform. Use this package to:

- **Instrument your AI agent SDKs** with standardized event tracking
- **Send telemetry data** to Chaukas-compatible backends
- **Track 19+ event types** across agent lifecycles, model invocations, tool calls, and errors
- **Enable distributed tracing** with full trace context propagation
- **Ensure compliance** with immutable audit trails

## Who should use this?

- **SDK developers** building agent frameworks who want to add observability
- **Agent builders** integrating telemetry into custom agents
- **Platform teams** sending events from client applications to observability backends

> **Note:** If you're implementing an observability backend/platform, use [`chaukas-spec-server`](https://pypi.org/project/chaukas-spec-server/) instead.

## Installation

```bash
pip install chaukas-spec-client
```

## Quick Start

```python
import grpc
from chaukas.spec.client.v1.client_pb2_grpc import ChaukasClientServiceStub
from chaukas.spec.client.v1.client_pb2 import IngestEventRequest
from chaukas.spec.common.v1.events_pb2 import Event, EventType

# Create gRPC channel to your Chaukas backend
channel = grpc.insecure_channel('localhost:50051')
stub = ChaukasClientServiceStub(channel)

# Create and send an event
event = Event(
    event_id="evt_123",
    type=EventType.EVENT_TYPE_AGENT_START,
    session_id="session_abc",
    trace_id="trace_xyz"
)

request = IngestEventRequest(event=event)
response = stub.IngestEvent(request)
```

## Event Types

The specification includes comprehensive event types for agent observability:

| Category | Event Types |
|----------|-------------|
| **Session** | SESSION_START, SESSION_END |
| **Agent** | AGENT_START, AGENT_END, AGENT_HANDOFF |
| **Model** | MODEL_INVOCATION_START, MODEL_INVOCATION_END |
| **Tools** | TOOL_CALL_START, TOOL_CALL_END, MCP_CALL_START, MCP_CALL_END |
| **I/O** | INPUT_RECEIVED, OUTPUT_EMITTED |
| **Errors** | ERROR, RETRY |
| **Extensions** | POLICY_DECISION, DATA_ACCESS, STATE_UPDATE, SYSTEM |

## Features

✅ **Standardized Schema** - Protocol Buffer definitions for all event types
✅ **gRPC Services** - High-performance service stubs for event ingestion
✅ **Type Safety** - Full type hints and validation
✅ **Distributed Tracing** - Built-in trace context support
✅ **Batch Operations** - Efficient batch event ingestion
✅ **Query Support** - Query events by session, trace, time range, and more

## Package Contents

```
chaukas/spec/
├── client/v1/       # Client gRPC service stubs
│   ├── client_pb2.py
│   └── client_pb2_grpc.py
└── common/v1/       # Shared event definitions
    ├── events_pb2.py
    └── query_pb2.py
```

## Documentation

- **Full Specification**: [chaukas-spec repository](https://github.com/chaukasai/chaukas-spec)
- **Protocol Definitions**: [proto/chaukas/spec/](https://github.com/chaukasai/chaukas-spec/tree/main/proto/chaukas/spec)
- **Architecture**: See [main README](https://github.com/chaukasai/chaukas-spec#architecture)
- **Examples**: [Usage examples](https://github.com/chaukasai/chaukas-spec#python-usage)

## Related Packages

- **[chaukas-sdk](https://pypi.org/project/chaukas-sdk/)** - One-line instrumentation for popular agent frameworks
- **[chaukas-spec-server](https://pypi.org/project/chaukas-spec-server/)** - Server-side implementation for building observability backends

## Contributing

We welcome contributions! Please see our [Contributing Guide](https://github.com/chaukasai/chaukas-spec/blob/main/CONTRIBUTING.md) and [Code of Conduct](https://github.com/chaukasai/chaukas-spec/blob/main/CODE_OF_CONDUCT.md).

## License

Apache 2.0 - See [LICENSE](https://github.com/chaukasai/chaukas-spec/blob/main/LICENSE) for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/chaukasai/chaukas-spec/issues)
- **Discussions**: [GitHub Discussions](https://github.com/chaukasai/chaukas-spec/discussions)
- **Security**: See [SECURITY.md](https://github.com/chaukasai/chaukas-spec/blob/main/SECURITY.md)
