package io.axoniq.testing.quicktester;

import io.axoniq.testing.quicktester.msg.TestCommand;
import org.axonframework.axonserver.connector.AxonServerConfiguration;
import org.axonframework.axonserver.connector.AxonServerConnectionManager;
import org.axonframework.axonserver.connector.command.AxonServerCommandBus;
import org.axonframework.commandhandling.CommandBus;
import org.axonframework.commandhandling.SimpleCommandBus;
import org.axonframework.commandhandling.distributed.AnnotationRoutingStrategy;
import org.axonframework.commandhandling.distributed.UnresolvedRoutingKeyPolicy;
import org.axonframework.commandhandling.gateway.CommandGateway;
import org.axonframework.serialization.Serializer;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class QuickTesterApplication {

    private final ApplicationContext ctx;

    public QuickTesterApplication(ApplicationContext ctx) {
        this.ctx = ctx;
    }

    public static void main(String[] args) {
        SpringApplication.run(QuickTesterApplication.class, args);
    }

    @Bean
    public CommandLineRunner getRunner(CommandGateway gwy) {
        return (args) -> {
            gwy.send(new TestCommand("QuickTesterApplication.getRunner", "Hi there!"));
            SpringApplication.exit(ctx);
        };
    }

    @Bean
    public CommandBus commandBus(AxonServerConfiguration config,
                                 AxonServerConnectionManager connectionManager,
                                 Serializer eventSerializer)
    {
        AnnotationRoutingStrategy strategy = new AnnotationRoutingStrategy(UnresolvedRoutingKeyPolicy.RANDOM_KEY);

        return AxonServerCommandBus.builder()
                .axonServerConnectionManager(connectionManager)
                .configuration(config)
                .localSegment(SimpleCommandBus.builder().build())
                .serializer(eventSerializer)
                .routingStrategy(strategy)
                .build();
    }
}
