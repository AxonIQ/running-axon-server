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
package io.axoniq.testing.quicktester;

import io.axoniq.testing.quicktester.msg.TestCommand;
import io.axoniq.testing.quicktester.msg.TestEvent;
import org.axonframework.commandhandling.CommandHandler;
import org.axonframework.eventhandling.EventHandler;
import org.axonframework.eventhandling.gateway.EventGateway;
import org.axonframework.messaging.MetaData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.lang.invoke.MethodHandles;

@Component
public class TestHandler {

    private static final Logger log = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

    private final EventGateway evtGwy;

    public TestHandler(EventGateway evtGwy) {
        this.evtGwy = evtGwy;
    }

    @CommandHandler
    public void processCommand(TestCommand cmd) {
        log.info("handleCommand(): src = \"{}\", msg = \"{}\".", cmd.getSrc(), cmd.getMsg());

        evtGwy.publish(new TestEvent(cmd.getSrc() + " says: " + cmd.getMsg()));
    }

    @EventHandler
    public void processEvent(TestEvent evt, MetaData metaData) {
        if (metaData.containsKey("Intercepted") && Boolean.TRUE.equals(metaData.get("Intercepted")))
        log.info("handleEvent(): msg = \"{}\".", evt.getMsg());
    }
}
