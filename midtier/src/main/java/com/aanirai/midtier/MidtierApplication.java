package com.aanirai.midtier;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class })
public class MidtierApplication {

	public static void main(String[] args) {
		SpringApplication.run(MidtierApplication.class, args);
	}

}
