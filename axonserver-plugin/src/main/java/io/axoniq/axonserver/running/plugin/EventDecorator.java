package io.axoniq.axonserver.running.plugin;

import io.axoniq.axonserver.grpc.MetaDataValue;
import io.axoniq.axonserver.grpc.event.Event;
import io.axoniq.axonserver.plugin.ExecutionContext;
import io.axoniq.axonserver.plugin.interceptor.ReadEventInterceptor;

public class EventDecorator implements ReadEventInterceptor {
    @Override
    public Event readEvent(Event event, ExecutionContext executionContext) {
        return Event.newBuilder(event)
                .putMetaData("Intercepted", MetaDataValue.newBuilder().setBooleanValue(true).build())
                .build();
    }
}
