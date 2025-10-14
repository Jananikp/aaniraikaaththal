package com.aanirai.midtier.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.Optional;

import com.aanirai.midtier.user.OAuthUser;
import com.aanirai.midtier.user.OAuthUserRepository;

@RestController
@RequestMapping("/api")
public class UserController {

    private final OAuthUserRepository oAuthUserRepository;

    public UserController(OAuthUserRepository oAuthUserRepository) {
        this.oAuthUserRepository = oAuthUserRepository;
    }

    @GetMapping("/user")
    public Map<String, Object> getUser(@AuthenticationPrincipal OAuth2User principal) {
        if (principal == null) return Map.of("name", null);
        String providerUserId = Optional.ofNullable(principal.getAttribute("sub")).map(String::valueOf).orElse(null);
        OAuthUser saved = providerUserId == null ? null : oAuthUserRepository.findByProviderUserId(providerUserId).orElse(null);
        return Map.of(
            "name", principal.getAttribute("name"),
            "email", principal.getAttribute("email"),
            "id", saved != null ? saved.getId() : null,
            "loginCount", saved != null ? saved.getLoginCount() : null,
            "lastLoginAt", saved != null ? String.valueOf(saved.getLastLoginAt()) : null
        );
    }
}
