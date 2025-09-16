<template>
  <section class="py-16 md:py-20 px-4 md:px-6 bg-gradient-to-br from-amber-100 to-yellow-100 min-h-screen">
    <div class="max-w-6xl mx-auto bg-[#FFF8DC] rounded-2xl shadow-2xl p-8 relative overflow-hidden">
      <h2 class="text-2xl md:text-3xl font-bold text-green-700 text-center mb-8">Meet our cows</h2>
      <p class="text-lg text-gray-600 mb-8">
        Our beloved cows are the heart of our farm, receiving the highest level of care and respect they deserve.
      </p>
      <!-- Carousel Controls -->
      <button @click="prev" class="absolute left-2 top-1/2 -translate-y-1/2 bg-white border border-gray-300 hover:border-green-700 shadow-lg rounded-full w-10 h-10 flex items-center justify-center transition z-10 opacity-80 hover:opacity-100">
        <span class="sr-only">Previous</span>
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-6 h-6 text-green-700">
          <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
        </svg>
      </button>
      <button @click="next" class="absolute right-2 top-1/2 -translate-y-1/2 bg-white border border-gray-300 hover:border-green-700 shadow-lg rounded-full w-10 h-10 flex items-center justify-center transition z-10 opacity-80 hover:opacity-100">
        <span class="sr-only">Next</span>
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-6 h-6 text-green-700">
          <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
        </svg>
      </button>
      <!-- Carousel Items -->
      <div class="flex gap-8 transition-transform duration-500" :style="carouselStyle">
        <div v-for="(cow, idx) in visibleCows" :key="cow.name + idx" class="min-w-[18rem] max-w-xs bg-green-50 rounded-xl shadow-lg p-4 flex flex-col items-center hover:scale-105 transition-transform duration-300">
          <img :src="cow.img" :alt="cow.name" class="w-56 h-56 object-cover rounded-xl shadow mb-3 border-4 border-white" />
          <h3 class="text-lg font-bold text-green-800 mb-1">{{ cow.name }}</h3>
          <p class="text-gray-700 text-center text-sm">{{ cow.nature }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'

const cows = [
  {
    name: 'Lakshmi',
    img: '/Lakshmi.jpg',
    nature: 'Gentle and nurturing, loves being around children.'
  },
  {
    name: 'Padma',
    img: '/Padma.jpg',
    nature: 'Curious and playful, enjoys grazing in open fields.'
  },
  {
    name: 'Balram',
    img: '/Balram.jpg',
    nature: 'Protective and calm, a leader among the herd.'
  },
  {
    name: 'Viraja',
    img: '/Viraja.jpg',
    nature: 'Shy but affectionate, prefers quiet corners.'
  },
  {
    name: 'Vardhan',
    img: '/Vardhan.jpg',
    nature: 'Energetic and friendly, loves visitors.'
  }
]

const visible = 3 // Number of cards visible at once
const current = ref(0)
let interval = null

const visibleCows = computed(() => {
  // Loop the cows so there is no gap at the end
  const result = []
  for (let i = 0; i < visible; i++) {
    result.push(cows[(current.value + i) % cows.length])
  }
  return result
})

const carouselStyle = computed(() => {
  return '' // No transform needed since we loop the cows
})

function next() {
  current.value = (current.value + 1) % cows.length
}
function prev() {
  current.value = (current.value - 1 + cows.length) % cows.length
}

onMounted(() => {
  interval = setInterval(() => {
    next()
  }, 3500)
})
onUnmounted(() => {
  if (interval) clearInterval(interval)
})
</script>
