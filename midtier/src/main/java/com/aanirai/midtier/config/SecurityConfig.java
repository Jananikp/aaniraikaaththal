package com.aanirai.midtier.config;

import org.springframework.core.env.Environment;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
public class SecurityConfig {

    private final String frontendUrl;

    public SecurityConfig(Environment env) {
        this.frontendUrl = env.getProperty("frontend.url", "http://localhost:5173");
    }

   @Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http, com.aanirai.midtier.auth.CustomOAuth2UserService customOAuth2UserService) throws Exception {
    http
        .cors(cors -> cors.configurationSource(corsConfigurationSource()))
        .csrf(csrf -> csrf.disable())
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/login**", "/error", "/oauth2/**", "/logout").permitAll()
            .anyRequest().authenticated()
        )
        .exceptionHandling(e -> e
            .authenticationEntryPoint((request, response, authException) -> {
                // If it's an API request, return 401 instead of redirecting
                if (request.getRequestURI().startsWith("/api/")) {
                    response.setStatus(401);
                } else {
                    // Redirect UI requests to Google login
                    response.sendRedirect(frontendUrl + "/login");
                    // Or: response.sendRedirect("/oauth2/authorization/google");
                }
            })
        )
        .oauth2Login(oauth2 -> oauth2
            .userInfoEndpoint(userInfo -> userInfo.userService(customOAuth2UserService))
            .defaultSuccessUrl(frontendUrl, true)
        )
        .logout(logout -> logout
            .logoutUrl("/logout")
            .deleteCookies("JSESSIONID")
            .invalidateHttpSession(true)
        );

    return http.build();
}
   @Bean
public UrlBasedCorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration config = new CorsConfiguration();
    config.setAllowCredentials(true);
    config.setAllowedOriginPatterns(List.of("http://localhost:5173", "https://eastcoastfarmer.com"));
    config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
    config.setAllowedHeaders(List.of("*"));

    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/api/**", config); // only needed for API
    source.registerCorsConfiguration("/oauth2/**", config); // if called via XHR (not recommended)
    return source;
}
}
