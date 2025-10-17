package com.aanirai.midtier.donation;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.http.ResponseEntity;
import org.springframework.beans.factory.annotation.Autowired; 

@RestController
@RequestMapping("/api/")
public class DonationController {
    @Autowired
    private DonationRepository donationRepository;
    @PostMapping("/donate")
    public ResponseEntity<String> donate(@RequestBody Donation donation) {
        donationRepository.save(donation);
        return ResponseEntity.ok("Donation received");
    }

}