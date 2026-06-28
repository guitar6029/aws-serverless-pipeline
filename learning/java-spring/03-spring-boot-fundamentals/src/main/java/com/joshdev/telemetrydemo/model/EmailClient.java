package com.joshdev.telemetrydemo.model;

public class EmailClient {

    private final String apiKey;

    public EmailClient(String apiKey) {
        this.apiKey = apiKey;
    }

    public String ping() {
        return "Email Client Connected! API Key = " + apiKey;
    }

}
