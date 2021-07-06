/* Copyright 2020 AxonIQ B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * ITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.axoniq.testing.quicktester.config;

import org.axonframework.axonserver.connector.AxonServerConnectionManager;
import org.axonframework.axonserver.connector.command.AxonServerCommandBus;
import org.axonframework.commandhandling.CommandBus;
import org.axonframework.commandhandling.SimpleCommandBus;
import org.axonframework.commandhandling.distributed.AnnotationRoutingStrategy;
import org.axonframework.commandhandling.distributed.UnresolvedRoutingKeyPolicy;
import org.axonframework.serialization.Serializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import java.lang.invoke.MethodHandles;
import java.util.HashMap;
import java.util.Map;

@Profile("axonserver")
@Component
public class QuickAxonServerConfiguration {

    private static final Logger log = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

    @Value("${tags:}")
    private String tagString;
    private final Map<String, String> commandTags = new HashMap<>();

    @Bean
    public CommandBus commandBus(org.axonframework.axonserver.connector.AxonServerConfiguration config,
                                 AxonServerConnectionManager connectionManager,
                                 Serializer eventSerializer,
                                 SpringProfiles profiles) {
        log.info("Setting up routing policy on a AxonServerCommandBus.");

        AnnotationRoutingStrategy strategy = AnnotationRoutingStrategy.builder()
                .fallbackRoutingStrategy(UnresolvedRoutingKeyPolicy.RANDOM_KEY)
                .build();

        final AxonServerCommandBus bus = AxonServerCommandBus.builder()
                .axonServerConnectionManager(connectionManager)
                .configuration(config)
                .localSegment(SimpleCommandBus.builder().build())
                .serializer(eventSerializer)
                .routingStrategy(strategy)
                .build();

        if (profiles.isActive("tagged")) {
            if ((tagString != null) && !tagString.isEmpty()) {
                for (String tag : tagString.split(",")) {
                    log.info("Adding tag '{}'", tag);
                    int index = tag.indexOf('=');
                    if (index != -1) {
                        commandTags.put(tag.substring(0, index), tag.substring(index + 1));
                    } else {
                        commandTags.put(tag, "");
                    }
                }
            } else {
                log.info("No tags found, no interceptor registered.");
            }
            log.info("Registering dispatchInterceptor");
            bus.registerDispatchInterceptor(messages -> (pos, msg) -> {
                log.info("Adding metadata to command.");
                return msg.andMetaData(commandTags);
            });
        }
        return bus;
    }

}
