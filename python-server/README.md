# Chaukas Server SDK

Server-side Python framework for implementing the Chaukas agent audit and explainability platform.

## Installation

```bash
pip install chaukas-spec-server
```

## Quick Start

### Basic Server Implementation

```python
import grpc
from concurrent import futures
from chaukas.spec.server.v1.server_pb2_grpc import (
    ChaukasServerServiceServicer, 
    add_ChaukasServerServiceServicer_to_server
)
from chaukas.spec.server.v1.server_pb2 import (
    IngestEventResponse,
    IngestEventBatchResponse, 
    GetCapabilitiesResponse,
    GetEventStatsResponse,
    HealthzResponse
)
from chaukas.spec.common.v1.events_pb2 import EventType

class MyChaukasServer(ChaukasServerServiceServicer):
    
    def Healthz(self, request, context):
        """Health check endpoint"""
        return HealthzResponse()
    
    def GetCapabilities(self, request, context):
        """Return server capabilities"""
        from chaukas.spec.common.v1.query_pb2 import Capabilities
        
        capabilities = Capabilities(
            supports_batch_ingestion=True,
            supports_event_querying=True,
            supports_statistics=True,
            max_batch_size=1000
        )
        return GetCapabilitiesResponse(capabilities=capabilities)
    
    def IngestEvent(self, request, context):
        """Handle single event ingestion"""
        event = request.event
        
        # Process the event (your implementation here)
        print(f"Received event: {event.event_id} of type {event.type}")
        
        return IngestEventResponse(
            event_id=event.event_id,
            status="accepted",
            processed_at=int(time.time() * 1000)  # Unix timestamp in ms
        )
    
    def IngestEventBatch(self, request, context):
        """Handle batch event ingestion"""
        events = request.event_batch.events
        accepted_count = 0
        rejected_event_ids = []
        
        for event in events:
            try:
                # Process each event (your implementation here)
                print(f"Processing event: {event.event_id}")
                accepted_count += 1
            except Exception as e:
                print(f"Failed to process {event.event_id}: {e}")
                rejected_event_ids.append(event.event_id)
        
        return IngestEventBatchResponse(
            batch_id=f"batch_{int(time.time())}",
            accepted_count=accepted_count,
            rejected_count=len(rejected_event_ids),
            rejected_event_ids=rejected_event_ids
        )
    
    def QueryEvents(self, request, context):
        """Handle event queries"""
        query = request.query
        
        # Implement your query logic here
        # This is a placeholder response
        from chaukas.spec.common.v1.query_pb2 import QueryResponse
        from chaukas.spec.common.v1.events_pb2 import Event
        
        # Example: return some events (enhanced with new fields)
        events = [
            Event(
                event_id="evt_example",
                type=EventType.EVENT_TYPE_SESSION_START,
                session_id=query.session_id or "default_session",
                trace_id=query.trace_id or "default_trace"  # New: trace correlation
            )
        ]
        
        response = QueryResponse(
            events=events,
            total_count=len(events),
            has_more=False
        )
        return QueryEventsResponse(response=response)
    
    def GetEventStats(self, request, context):
        """Get event statistics"""
        # Implement your statistics logic here
        return GetEventStatsResponse(
            total_events=1000,
            total_sessions=50,
            events_by_type={
                str(EventType.EVENT_TYPE_SESSION_START): 50,
                str(EventType.EVENT_TYPE_AGENT_START): 200,
            },
            avg_session_duration_ms=30000.0
        )

### Working with New Event Types

```python
from chaukas.spec.common.v1.events_pb2 import (
    Event, EventType, AgentHandoff, MCPCall, ToolCall
)
from google.protobuf.struct_pb2 import Struct

def handle_agent_handoff_event(self, event):
    """Process agent handoff events"""
    if event.HasField('agent_handoff'):
        handoff = event.agent_handoff
        print(f"Agent handoff: {handoff.from_agent_name} -> {handoff.to_agent_name}")
        print(f"Reason: {handoff.reason}")
        print(f"Type: {handoff.handoff_type}")

def handle_mcp_call_event(self, event):
    """Process MCP call events"""
    if event.HasField('mcp_call'):
        mcp = event.mcp_call
        print(f"MCP Call: {mcp.server_name} - {mcp.operation}")
        print(f"Execution time: {mcp.execution_time_ms}ms")

def create_enhanced_tool_event(self):
    """Create tool event with enhanced function tracking"""
    tool_call = ToolCall(
        id="call_123",
        name="calculator",
        function_name="multiply",  # New: granular function tracking
        auth_required=False
    )
    
    return Event(
        event_id="evt_tool_456",
        type=EventType.EVENT_TYPE_TOOL_CALL_START,
        trace_id="trace_abc123",  # New: distributed tracing
        tool_call=tool_call
    )

# Run the server
def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    add_ChaukasServerServiceServicer_to_server(MyChaukasServer(), server)
    
    listen_addr = '[::]:50051'
    server.add_insecure_port(listen_addr)
    
    print(f"Starting Chaukas server on {listen_addr}")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    import time
    serve()
```

### Event Processing Patterns

#### Stream Processing

```python
def IngestEventBatch(self, request, context):
    """Process events in streaming fashion"""
    for event in request.event_batch.events:
        # Validate event
        if not self.validate_event(event):
            continue
            
        # Transform event
        processed_event = self.transform_event(event)
        
        # Store event
        self.store_event(processed_event)
        
        # Trigger real-time processing
        self.process_event_async(processed_event)
    
    return IngestEventBatchResponse(
        accepted_count=len(request.event_batch.events),
        rejected_count=0
    )
```

#### Event Validation

```python
from chaukas.spec.common.v1.events_pb2 import EventStatus, Severity

def validate_event(self, event):
    """Validate incoming event"""
    if not event.event_id:
        return False
    
    if not event.tenant_id:
        return False
        
    if event.type == EventType.EVENT_TYPE_UNSPECIFIED:
        return False
        
    return True

def enrich_event(self, event):
    """Add server-side metadata"""
    import time
    from google.protobuf.timestamp_pb2 import Timestamp
    
    # Add server timestamp
    now = Timestamp()
    now.GetCurrentTime()
    event.server_timestamp.CopyFrom(now)
    
    # Set processing status
    event.status = EventStatus.EVENT_STATUS_IN_PROGRESS
    
    return event
```

#### Database Integration Example

```python
import asyncio
import aiopg

class AsyncChaukasServer(ChaukasServerServiceServicer):
    
    def __init__(self):
        self.db_pool = None
    
    async def init_db(self):
        """Initialize database connection pool"""
        self.db_pool = await aiopg.create_pool(
            "postgresql://user:pass@localhost/chaukas"
        )
    
    def IngestEvent(self, request, context):
        """Handle single event with async processing"""
        event = request.event
        
        # Run async processing in background
        asyncio.create_task(self.store_event_async(event))
        
        return IngestEventResponse(
            event_id=event.event_id,
            status="accepted"
        )
    
    async def store_event_async(self, event):
        """Store event in database asynchronously"""
        async with self.db_pool.acquire() as conn:
            async with conn.cursor() as cur:
                await cur.execute(
                    "INSERT INTO events (id, type, data) VALUES (%s, %s, %s)",
                    (event.event_id, event.type, event.SerializeToString())
                )
```

## Available Message Types

### Core Events
- `Event` - Core event structure with trace_id for distributed tracing
- `EventBatch` - Batch of events for bulk processing
- `EventType` - Comprehensive enumeration including AGENT_HANDOFF, MCP_CALL_START/END
- `EventStatus` - Event processing status
- `Severity` - Event severity levels

### Enhanced Content Types
- `MessageContent` - User/agent/system messages
- `ToolCall` - Tool invocations with enhanced function_name field
- `ToolResponse` - Tool execution results  
- `LLMInvocation` - Language model calls
- `AgentHandoff` - **New**: Agent-to-agent transition tracking
- `MCPCall` - **New**: Model Context Protocol call details
- `PolicyDecision` - Policy enforcement results
- `DataAccess` - Data retrieval operations
- `ErrorInfo` - Error information and recovery

### Server Responses
- `IngestEventResponse` - Single event ingestion result
- `IngestEventBatchResponse` - Batch ingestion result with detailed status
- `GetEventStatsResponse` - Statistics about stored events

### Query Support
- `QueryRequest` - Event query parameters
- `QueryFilter` - **Enhanced**: Now includes trace_id filtering
- `QueryResponse` - Query results with pagination
- `TimeRange` - Time-based filtering
- `SortOrder` - Result ordering options

## Error Handling

```python
import grpc

def IngestEvent(self, request, context):
    try:
        # Process event
        result = self.process_event(request.event)
        return IngestEventResponse(event_id=request.event.event_id, status="accepted")
        
    except ValidationError as e:
        context.set_code(grpc.StatusCode.INVALID_ARGUMENT)
        context.set_details(str(e))
        return IngestEventResponse()
        
    except StorageError as e:
        context.set_code(grpc.StatusCode.INTERNAL)
        context.set_details("Failed to store event")
        return IngestEventResponse()
        
    except Exception as e:
        context.set_code(grpc.StatusCode.UNKNOWN)
        context.set_details("Unexpected error occurred")
        return IngestEventResponse()
```

## Development

This package contains generated Protocol Buffer code. For development instructions and to contribute to the specification, see the main repository:

https://github.com/chaukasai/spec

## License

Apache License 2.0 - see the main repository for details.