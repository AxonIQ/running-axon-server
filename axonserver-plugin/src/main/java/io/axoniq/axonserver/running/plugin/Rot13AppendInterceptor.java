package io.axoniq.axonserver.running.plugin;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.protobuf.ByteString;
import io.axoniq.axonserver.grpc.MetaDataValue;
import io.axoniq.axonserver.grpc.SerializedObject;
import io.axoniq.axonserver.grpc.event.Event;
import io.axoniq.axonserver.plugin.ExecutionContext;
import io.axoniq.axonserver.plugin.interceptor.AppendEventInterceptor;
import io.axoniq.axonserver.plugin.interceptor.ReadEventInterceptor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Map;

public class Rot13AppendInterceptor implements AppendEventInterceptor, ReadEventInterceptor {

    private static final Logger log = LoggerFactory.getLogger(Rot13AppendInterceptor.class);

    public static final String TARGET_TYPE = "io.axoniq.testing.quicktester.msg.TestEvent";

    public static final String ROT_13_ENCRYPTED = "Rot13Encrypted";

    public static String rot13(String input) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < input.length(); i++) {
            char c = input.charAt(i);
            if (c >= 'a' && c <= 'm') c += 13;
            else if (c >= 'A' && c <= 'M') c += 13;
            else if (c >= 'n' && c <= 'z') c -= 13;
            else if (c >= 'N' && c <= 'Z') c -= 13;
            sb.append(c);
        }
        return sb.toString();
    }

    private final ObjectMapper myMapper = new ObjectMapper();

    private final MetaDataValue trueValue = MetaDataValue.newBuilder().setBooleanValue(true).build();
    private final MetaDataValue falseValue = MetaDataValue.newBuilder().setBooleanValue(false).build();

    @Override
    public Event appendEvent(Event event, ExecutionContext executionContext) {
        final SerializedObject payload = event.getPayload();
        if (payload.getType().equals(TARGET_TYPE)) {
            try {
                return Event.newBuilder(event)
                        .setPayload(convertPayload(payload))
                        .putMetaData(ROT_13_ENCRYPTED, trueValue)
                        .build();
            } catch (IOException e) {
                log.error("Failed to encrypt message: {}", e.getMessage());
            }
        } else {
            log.debug("appendEvent: Wrong type of event: '{}' (will only touch '{}')", payload.getType(), TARGET_TYPE);
        }
        return event;
    }

    private static boolean isEncrypted(Event event) {
        final Map<String, MetaDataValue> metaDataMap = event.getMetaDataMap();
        if (metaDataMap.containsKey(ROT_13_ENCRYPTED)) {
            return metaDataMap.get(ROT_13_ENCRYPTED).getBooleanValue();
        }
        return false;
    }

    @Override
    public Event readEvent(Event event, ExecutionContext executionContext) {
        final SerializedObject payload = event.getPayload();
        if (payload.getType().equals(TARGET_TYPE) && isEncrypted(event)) {
            try {
                final SerializedObject.Builder convertedPayload = convertPayload(payload);
                log.debug("readEvent: Decrypted the message in a '{}'", payload.getType());
                return Event.newBuilder(event)
                        .setPayload(convertedPayload)
                        .build();
            } catch (IOException e) {
                log.error("Failed to decrypt message: {}", e.getMessage());
            }
        } else if (!isEncrypted(event)) {
            log.debug("readEvent: Not encrypted.");
        } else {
            log.debug("readEvent: Wrong type of event: '{}' (will only touch '{}')", payload.getType(), TARGET_TYPE);
        }
        return event;
    }

    @SuppressWarnings("unchecked")
    private SerializedObject.Builder convertPayload(SerializedObject payload) throws IOException {
        String oldMsg = "";

        final Map<String, String> payloadMap = myMapper.readValue(payload.getData().toByteArray(), Map.class);
        oldMsg = payloadMap.get("msg");
        final String newMsg = rot13(oldMsg);
        payloadMap.put("msg", newMsg);

        return SerializedObject.newBuilder(payload)
                .setData(ByteString.copyFrom(myMapper.writeValueAsBytes(payloadMap)));
    }
}
