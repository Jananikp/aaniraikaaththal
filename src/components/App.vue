<template>
    <div>
      <Navbar />
  
      <!-- Call Home.vue sections -->
    <Home id="home-sections" />

  
      <!-- Other Sections -->
      <section id="our-cows" class="py-20 bg-amber-50">Our Cows Section</section>
      <section id="daily-activities" class="py-20">Daily Activities</section>
      <section id="community" class="py-20 bg-amber-50">Community Section</section>
      <section id="get-involved" class="py-20">Get Involved Section</section>
      <section id="contact" class="py-20 bg-green-50">Contact Section</section>
    </div>
  </template>
  
  <script setup>
  import Navbar from './components/Navbar.vue'
  import Home from './components/Home.vue'
  </script>
  
  <style>
  html {
    scroll-behavior: smooth;
  }
  </style>
  