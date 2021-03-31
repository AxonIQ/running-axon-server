package io.axoniq.testing.quicktester.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;

import static java.util.Arrays.asList;

@Component
public class SpringProfiles {

    @Value("${spring.profiles.active:default}")
    private String profiles;
    private Set<String> profileSet = null;

    public boolean isActive(final String profile) {
        if (profileSet == null) {
            profileSet = new HashSet<>(asList(profiles.split(",")));
        }

        return profileSet.contains(profile);
    }
}
