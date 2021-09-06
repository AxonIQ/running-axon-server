package io.axoniq.axonserver.running.plugin;

import io.axoniq.axonserver.plugin.interceptor.AppendEventInterceptor;
import io.axoniq.axonserver.plugin.interceptor.ReadEventInterceptor;
import org.osgi.framework.BundleActivator;
import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceRegistration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashSet;
import java.util.Set;

public class PluginActivator implements BundleActivator {

    private static final Logger log = LoggerFactory.getLogger(PluginActivator.class);

    private final Set<ServiceRegistration<?>> registration = new HashSet<>();

    public void start(BundleContext bundleContext) {
        log.debug("Registering services");
        registration.add(bundleContext.registerService(ReadEventInterceptor.class, new EventDecorator(), null));

        registration.add(bundleContext.registerService(ReadEventInterceptor.class, new Rot13AppendInterceptor(), null));
        registration.add(bundleContext.registerService(AppendEventInterceptor.class, new Rot13AppendInterceptor(), null));
    }

    public void stop(BundleContext bundleContext) {
        registration.forEach(ServiceRegistration::unregister);
    }
}