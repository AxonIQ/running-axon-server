package io.axoniq.testing.quicktester;

import io.axoniq.testing.quicktester.msg.TestCommand;
import io.axoniq.testing.quicktester.msg.TestEvent;
import org.axonframework.commandhandling.CommandHandler;
import org.axonframework.eventhandling.EventHandler;
import org.axonframework.eventhandling.gateway.EventGateway;
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
    public void processEvent(TestEvent evt) {
        log.info("handleEvent(): msg = \"{}\".", evt.getMsg());
    }
}
