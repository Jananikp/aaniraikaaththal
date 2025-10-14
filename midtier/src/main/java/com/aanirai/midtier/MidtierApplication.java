package com.aanirai.midtier;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@SpringBootApplication
public class MidtierApplication {

    private static final Logger log = LoggerFactory.getLogger(MidtierApplication.class);

	public static void main(String[] args) {
        String profile = System.getenv("SPRING_PROFILES_ACTIVE");
        String dbUrl = System.getenv("DB_URL");
        String dbUser = System.getenv("DB_USERNAME");
        System.out.println("[DB DEBUG BOOT] SPRING_PROFILES_ACTIVE=" + profile);
        System.out.println("[DB DEBUG BOOT] DB_URL=" + dbUrl);
        System.out.println("[DB DEBUG BOOT] DB_USERNAME=" + dbUser);
        if (dbUrl == null) {
            System.out.println("[DB DEBUG BOOT] WARNING: DB_URL is not set");
        }
		SpringApplication.run(MidtierApplication.class, args);
	}

}
