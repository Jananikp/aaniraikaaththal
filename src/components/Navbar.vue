<template>
  <nav class="navbar">
    <div class="navbar-container" style="justify-content: space-between;">
      
      <!-- Logo + Name left-aligned -->
      <div class="navbar-logo" style="margin-left:0;">
        <img src="/aanirailogo.png" alt="Aanirai Kaaththal" class="navbar-logo-img" />
        <span class="navbar-logo-text">Aanirai Kaaththal</span>
      </div>

      <!-- Desktop Nav centered absolutely -->
      <div class="navbar-links hidden md:flex" style="position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%); margin-left:0;">
        <router-link to="/" class="navbar-link">About Us</router-link>
        <router-link to="/our-cows" class="navbar-link">Our Cows</router-link>
        <router-link to="/daily-activities" class="navbar-link">Daily Activities</router-link>
        <router-link to="/community" class="navbar-link">Community</router-link>
        <router-link to="/get-involved" class="navbar-link">Get Involved</router-link>
        <router-link to="/contact" class="navbar-link">Contact</router-link>
      </div>

      <!-- Mobile Toggle -->
      <button class="navbar-toggle md:hidden" @click="isOpen = !isOpen" aria-label="Toggle menu">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
             stroke-width="2" stroke="currentColor" class="w-7 h-7">
          <path stroke-linecap="round" stroke-linejoin="round"
                d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>
    </div>

    <!-- Mobile Menu -->
    <div v-if="isOpen" class="navbar-mobile md:hidden">
      <div class="navbar-mobile-links">
        <router-link to="/" class="navbar-link" @click="isOpen = false">About Us</router-link>
        <router-link to="/our-cows" class="navbar-link" @click="isOpen = false">Our Cows</router-link>
        <router-link to="/daily-activities" class="navbar-link" @click="isOpen = false">Daily Activities</router-link>
        <router-link to="/community" class="navbar-link" @click="isOpen = false">Community</router-link>
        <router-link to="/get-involved" class="navbar-link" @click="isOpen = false">Get Involved</router-link>
        <router-link to="/contact" class="navbar-link" @click="isOpen = false">Contact</router-link>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { ref } from 'vue'
const isOpen = ref(false)
</script>
