package com.joshdev.telemetrydemo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.joshdev.telemetrydemo.model.EmailClient;

@Configuration
public class AppConfig {

    @Bean
    public EmailClient emailClient() {

        return new EmailClient(
                "super-secret-api-key"
        );

    }

}
