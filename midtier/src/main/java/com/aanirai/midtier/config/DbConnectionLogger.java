package com.aanirai.midtier.config;

import javax.sql.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

@Component
public class DbConnectionLogger implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(DbConnectionLogger.class);

    private final Environment environment;
    private final DataSource dataSource;

    public DbConnectionLogger(Environment environment, DataSource dataSource) {
        this.environment = environment;
        this.dataSource = dataSource;
    }

    @Override
    public void run(ApplicationArguments args) {
        String activeProfiles = String.join(", ", environment.getActiveProfiles());
        String dsUrl = environment.getProperty("spring.datasource.url");
        String dsUser = environment.getProperty("spring.datasource.username");
        String envDbUrl = environment.getProperty("DB_URL");
        String envDbUser = environment.getProperty("DB_USERNAME");

        log.info("[DB DEBUG] Active profiles: {}", activeProfiles);
        log.info("[DB DEBUG] spring.datasource.url: {}", dsUrl);
        log.info("[DB DEBUG] spring.datasource.username: {}", dsUser);
        log.info("[DB DEBUG] env DB_URL: {}", envDbUrl);
        log.info("[DB DEBUG] env DB_USERNAME: {}", envDbUser);
        log.info("[DB DEBUG] DataSource implementation: {}", dataSource != null ? dataSource.getClass().getName() : "(null)");

        try {
            // Avoid opening a real connection; just log meta if available
            Class<?> hikariClass = Class.forName("com.zaxxer.hikari.HikariDataSource");
            if (hikariClass.isInstance(dataSource)) {
                Object jdbcUrl = hikariClass.getMethod("getJdbcUrl").invoke(dataSource);
                Object username = hikariClass.getMethod("getUsername").invoke(dataSource);
                log.info("[DB DEBUG] Hikari jdbcUrl: {}", jdbcUrl);
                log.info("[DB DEBUG] Hikari username: {}", username);
            }
        } catch (ClassNotFoundException e) {
            // Hikari not on classpath or different pool; ignore
        } catch (Exception e) {
            log.warn("[DB DEBUG] Unable to introspect DataSource: {}", e.getMessage());
        }
    }
}


