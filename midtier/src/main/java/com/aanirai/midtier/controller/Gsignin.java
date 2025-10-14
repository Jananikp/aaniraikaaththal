package com.aanirai.midtier.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;



public class Gsignin{
@GetMapping("/login")
    public String login(@AuthenticationPrincipal OAuth2User principal, Model model) {
        if (principal  != null) {
               model.addAttribute("name", principal.getAttribute("name"));
                model.addAttribute("email", principal.getAttribute("email"));   
                model.addAttribute("userInitial",((String) principal.getAttribute("name")).substring(0, 1));
        }
        return "Login successful!";
    }

}
