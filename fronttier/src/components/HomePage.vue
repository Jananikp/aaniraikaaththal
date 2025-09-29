<template>
  <div>
    <Navbar />
    <div id="home">
      <Home />
    </div>
    <section id="our-cows" class="py-16 md:py-20 px-4 md:px-6 bg-gradient-to-br from-amber-100 to-yellow-100">
      <OurCows />
    </section>
    <section id="daily-activities" class="py-16 md:py-20 px-4 md:px-6 bg-gradient-to-br from-amber-100 to-yellow-100">
      <h2 class="text-2xl md:text-3xl font-bold text-center mb-8 text-green-700">Daily Activities</h2>
      <div class="max-w-6xl mx-auto md:grid md:grid-cols-2 md:gap-10 items-start">
        <!-- ...existing code for activities... -->
      </div>
    </section>
    <section id="community" class="py-16 md:py-20 px-4 md:px-6 bg-gradient-to-br from-amber-100 to-yellow-100">
      <div class="max-w-4xl mx-auto text-center">
        <h2 class="text-2xl md:text-3xl font-bold text-center mb-8 text-green-700">Community & Educational Experiences</h2>
        <p class="text-lg text-gray-600 mb-8">
          At Aghnya, sustainability thrives when communities come together. Our farm is a living classroom where families, students, and urban communities reconnect with nature.
        </p>
      </div>
      <div class="max-w-5xl mx-auto mt-8">
        <CommunityExperiences />
      </div>
      <div class="max-w-4xl mx-auto grid md:grid-cols-2 gap-8 mt-12">
        <!-- ...existing code for community cards... -->
      </div>
    </section>
    <GetInvolved />
    <section id="contact" class="py-16 md:py-20 px-4 md:px-6 bg-gradient-to-br from-amber-100 to-yellow-100">
      <div class="max-w-4xl mx-auto text-center">
        <h2 class="text-2xl md:text-3xl font-bold mb-6 text-green-700">Contact Us</h2>
        <p class="text-lg text-gray-600 mb-8">
          Get in touch with us to learn more or schedule a farm visit.
        </p>
        <div class="grid md:grid-cols-2 gap-8 mt-12">
          <!-- ...existing code for contact cards... -->
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import Navbar from '../components/Navbar.vue'
import Home from '../components/Home.vue'
import CommunityExperiences from '../components/Community.vue'
import OurCows from '../components/OurCows.vue'
import GetInvolved from '../components/GetInvolved.vue'
</script>
