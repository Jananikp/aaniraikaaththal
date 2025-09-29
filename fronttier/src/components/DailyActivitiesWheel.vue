<template>
  <section class="min-h-screen py-16 md:py-20 px-4 md:px-6 bg-gradient-to-br from-amber-100 to-yellow-100 flex flex-col items-center justify-center font-sans">
    <div class="max-w-4xl w-full mx-auto flex flex-col md:flex-row gap-10 items-center">
      <!-- Left: Zoomed active card -->
      <div class="flex-1 flex justify-center items-center mb-8 md:mb-0">
        <div class="bg-white/90 rounded-2xl shadow-2xl p-8 flex flex-col items-center text-center transition-all duration-500" style="min-width: 320px; min-height: 320px;">
          <img :src="activityCards[currentScroll].img" :alt="activityCards[currentScroll].title" class="w-32 h-32 md:w-40 md:h-40 object-cover rounded-full mb-4 shadow-lg scale-110" />
          <h3 class="text-2xl font-bold text-green-700 mb-2">{{ activityCards[currentScroll].title }}</h3>
          <p class="text-gray-700 text-base">{{ activityCards[currentScroll].desc }}</p>
        </div>
      </div>
      <!-- Right: Auto-scrolling vertical list -->
      <div class="flex-1 max-w-md w-full mx-auto overflow-hidden relative group" style="height: 340px;">
        <div
          class="transition-transform duration-700"
          :style="{ transform: `translateY(-${currentScroll * cardHeight}px)` }"
          @mouseenter="pauseScroll"
          @mouseleave="resumeScroll"
        >
          <div v-for="(card, idx) in activityCards" :key="card.title + idx"
            class="bg-white/90 rounded-xl shadow-md p-6 flex flex-col items-center text-center mb-4 transition-all duration-300"
            :class="{ 'ring-4 ring-green-600 scale-105 z-10': idx === currentScroll }"
            style="min-height: 150px;">
            <img :src="card.img" :alt="card.title" class="w-16 h-16 object-cover rounded-full mb-3 shadow" />
            <h3 class="text-lg font-bold text-green-700 mb-1">{{ card.title }}</h3>
            <p class="text-gray-700 text-sm">{{ card.desc }}</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const activityCards = [
  {
    title: 'Cleaning Shelter',
    img: '/cleaning.jpg',
    desc: 'Keeping the shelter clean is our first act of seva — ensuring cows live in a pure, calm, and sacred environment.'
  },
  {
    title: 'Dung Collection',
    img: '/dung.jpg',
    desc: 'We collect cow dung daily, which is then used as a natural fertilizer and for making panchakavya.'
  },
  {
    title: 'Feeding',
    img: '/feedingcow.jpg',
    desc: 'Feeding our cows with fresh fodder and water, ensuring their health and happiness.'
  },
  {
    title: 'Grazing',
    img: '/grazing.jpg',
    desc: 'Allowing cows to graze freely in open pastures, connecting them with nature.'
  },
  {
    title: 'Natural Farming',
    img: '/naturalfarming.jpg',
    desc: 'Using traditional methods and cow-based products to nurture the land and grow healthy crops.'
  }
]

const currentScroll = ref(0)
const cardHeight = 154 // px (card min-height + margin)
let scrollTimer: number | undefined
let isPaused = false

function autoScroll() {
  if (isPaused) return
  currentScroll.value = (currentScroll.value + 1) % activityCards.length
}
function pauseScroll() {
  isPaused = true
}
function resumeScroll() {
  isPaused = false
}

onMounted(() => {
  scrollTimer = window.setInterval(() => {
    if (!isPaused) autoScroll()
  }, 2500)
})
onUnmounted(() => {
  if (scrollTimer) window.clearInterval(scrollTimer)
})
</script>

<style scoped>
/* No additional styles needed; uses global font and Tailwind for consistency */
</style>

