# Chaukas Client SDK

Client-side Python SDK for the Chaukas agent audit and explainability platform.

## Installation

```bash
pip install chaukas-spec-client
```

## Quick Start

### Basic Client Usage

```python
import grpc
from chaukas.spec.client.v1.client_pb2_grpc import ChaukasClientServiceStub
from chaukas.spec.client.v1.client_pb2 import IngestEventRequest, HealthzRequest
from chaukas.spec.common.v1.events_pb2 import Event, EventType

# Create gRPC channel and client
channel = grpc.insecure_channel('localhost:50051')
client = ChaukasClientServiceStub(channel)

# Health check
health_request = HealthzRequest()
health_response = client.Healthz(health_request)
print("Service is healthy!")

# Create and send an event
event = Event(
    event_id="evt_123",
    type=EventType.EVENT_TYPE_AGENT_START,
    session_id="session_abc",
    tenant_id="tenant_123",
    project_id="project_456"
)

request = IngestEventRequest(event=event)
response = client.IngestEvent(request)
print("Event ingested successfully!")
```

### Available Event Types

```python
from chaukas.spec.common.v1.events_pb2 import EventType

# Session lifecycle
EventType.EVENT_TYPE_SESSION_START
EventType.EVENT_TYPE_SESSION_END

# Agent spans  
EventType.EVENT_TYPE_AGENT_START
EventType.EVENT_TYPE_AGENT_END
EventType.EVENT_TYPE_AGENT_HANDOFF

# LLM/Tool spans
EventType.EVENT_TYPE_MODEL_INVOCATION_START
EventType.EVENT_TYPE_MODEL_INVOCATION_END
EventType.EVENT_TYPE_TOOL_CALL_START
EventType.EVENT_TYPE_TOOL_CALL_END

# MCP (Model Context Protocol) spans
EventType.EVENT_TYPE_MCP_CALL_START
EventType.EVENT_TYPE_MCP_CALL_END

# I/O Events
EventType.EVENT_TYPE_INPUT_RECEIVED
EventType.EVENT_TYPE_OUTPUT_EMITTED

# Error handling
EventType.EVENT_TYPE_ERROR
EventType.EVENT_TYPE_RETRY
```

### Batch Event Ingestion

```python
from chaukas.spec.client.v1.client_pb2 import IngestEventBatchRequest
from chaukas.spec.common.v1.events_pb2 import EventBatch

# Create multiple events
events = [
    Event(event_id="evt_1", type=EventType.EVENT_TYPE_SESSION_START),
    Event(event_id="evt_2", type=EventType.EVENT_TYPE_AGENT_START),
]

batch = EventBatch(events=events)
request = IngestEventBatchRequest(event_batch=batch)
response = client.IngestEventBatch(request)
print("Event batch ingested!")
```

### Querying Events

```python
from chaukas.spec.client.v1.client_pb2 import QueryEventsRequest
from chaukas.spec.common.v1.query_pb2 import QueryRequest, QueryFilter, SortOrder

# Query events with enhanced filtering
filter = QueryFilter(
    tenant_id="tenant_123",
    project_id="project_456",
    trace_id="trace_abc123",  # New: Filter by distributed trace ID
    session_id="session_abc"
)

query = QueryRequest(
    filter=filter,
    page_size=100,
    order_by_time=SortOrder.SORT_ORDER_DESC
)

request = QueryEventsRequest(query=query)
response = client.QueryEvents(request)

print(f"Found {len(response.response.events)} events")
for event in response.response.events:
    print(f"- {event.event_id}: {event.type} (trace: {event.trace_id})")
```

### Advanced Event Creation with New Fields

```python
# Create event with distributed tracing
event = Event(
    event_id="evt_123",
    type=EventType.EVENT_TYPE_AGENT_HANDOFF,
    session_id="session_abc",
    tenant_id="tenant_123", 
    project_id="project_456",
    trace_id="trace_abc123"  # New: Distributed trace correlation
)

# Enhanced tool call with function name
from chaukas.spec.common.v1.events_pb2 import ToolCall
from google.protobuf.struct_pb2 import Struct

tool_call = ToolCall(
    id="call_123",
    name="calculator",
    function_name="multiply",  # New: Specific function within tool
    arguments=Struct()  # Add your arguments here
)

tool_event = Event(
    event_id="evt_tool_456",
    type=EventType.EVENT_TYPE_TOOL_CALL_START,
    trace_id="trace_abc123",
    tool_call=tool_call
)
```

## Error Handling

```python
import grpc

try:
    response = client.IngestEvent(request)
except grpc.RpcError as e:
    if e.code() == grpc.StatusCode.UNAVAILABLE:
        print("Service unavailable")
    elif e.code() == grpc.StatusCode.INVALID_ARGUMENT:
        print("Invalid request:", e.details())
    else:
        print(f"RPC failed: {e}")
```

## Development

This package contains generated Protocol Buffer code. For development instructions and to contribute to the specification, see the main repository:

https://github.com/chaukasai/spec

## License

Apache License 2.0 - see the main repository for details.