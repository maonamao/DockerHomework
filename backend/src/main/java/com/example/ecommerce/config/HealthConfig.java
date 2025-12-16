package com.example.ecommerce.config;

import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

import java.net.InetAddress;
import java.net.UnknownHostException;

@Component
public class HealthConfig implements HealthIndicator {
    
    @Override
    public Health health() {
        try {
            String hostName = InetAddress.getLocalHost().getHostName();
            return Health.up()
                    .withDetail("hostname", hostName)
                    .withDetail("service", "ecommerce-backend")
                    .withDetail("timestamp", System.currentTimeMillis())
                    .build();
        } catch (UnknownHostException e) {
            return Health.down()
                    .withDetail("error", e.getMessage())
                    .build();
        }
    }
}
