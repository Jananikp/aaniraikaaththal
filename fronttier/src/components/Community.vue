<template>
  <section class="py-16 md:py-20 px-4 md:px-6 bg-gradient-to-br from-amber-100 to-yellow-100 min-h-screen">
    <div class="max-w-5xl mx-auto bg-[#FFF8DC] rounded-xl shadow-lg p-8">
      <h2 class="text-2xl md:text-3xl font-bold text-center mb-4 text-green-700">A Day at the Farm – Community Workshops</h2>
      <p class="text-lg text-black mb-8 text-center">
        Whether you are a school looking for experiential learning, parents seeking meaningful activities for children, or adults longing to reconnect with nature — our farm welcomes you into a circle of care and community.
      </p>
      <div class="flex flex-col md:flex-row gap-10">
        <!-- Photo Grid -->
        <div class="md:w-1/2 grid grid-cols-2 gap-6">
          <div
            v-for="(activity, idx) in activities"
            :key="activity.title"
            @click="selectActivity(idx)"
            class="cursor-pointer transition-transform duration-300 ease-out"
          >
            <div
              :class="[
                'bg-white border-4 border-[#e5e3da] shadow-xl p-2 rounded-lg',
                'flex flex-col items-center',
                'transform',
                'hover:scale-105 hover:-rotate-2',
                selectedIdx === idx ? 'ring-4 ring-[#8c7b5a]' : '',
                polaroidRotation(idx)
              ]"
              style="transition: box-shadow 0.3s, transform 0.3s;"
            >
              <img
                :src="activity.img"
                :alt="activity.title"
                class="w-full h-40 object-cover rounded mb-2"
              />
              <span class="text-sm font-serif text-[#6b4f2a] mt-1">{{ activity.title }}</span>
            </div>
          </div>
        </div>
        <!-- Story Panel -->
        <div class="md:w-1/2 flex items-center">
          <transition name="fade" mode="out-in">
            <div
              :key="selectedIdx"
              class="bg-[#e5e3da] rounded-xl p-8 w-full min-h-[220px] flex flex-col justify-center shadow-md"
            >
              <div v-if="selectedActivity && selectedActivity.video" class="mb-4">
                <video
                  :src="selectedActivity.video"
                  controls
                  autoplay
                  class="w-full rounded-lg shadow"
                  :poster="selectedActivity.img"
                  style="max-height:220px;object-fit:cover;"
                >
                  Your browser does not support the video tag.
                </video>
              </div>
              <h3 v-if="selectedActivity" class="text-xl md:text-2xl font-serif font-semibold text-[#4e3b1f] mb-3">
                {{ selectedActivity.title }}
              </h3>
              <p class="text-[#5c4321] text-base md:text-lg font-sans">
                {{ selectedActivity ? selectedActivity.desc : "Select an experience to learn more." }}
              </p>
            </div>
          </transition>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed } from 'vue'

// Updated activities array with new titles and adjusted content
const activities = [
  {
    title: "Bonding with Animals",
    img: "/childbond2.jpg",
    desc: "Experience the joy of connecting with cows and other animals, fostering empathy and gentle care through hands-on interaction.",
    video: "/public/bonding_animals.mp4"
  },
  {
    title: "Panchakavya & Natural Care",
    img: "/composting.jpg",
    desc: "Discover the science and tradition behind Panchakavya and natural animal care, learning how these practices sustain our farm.",
    video: "/public/composting.mp4"
  },
  {
    title: "Sustainable Farming Practices",
    img: "/farming.jpg",
    desc: "Participate in hands-on farming and learn sustainable, eco-friendly techniques that nurture the land and our community.",
    video: "/public/farming.mp4"
  },
  {
    title: "Living Sustainably – Farm Tour",
    img: "/sustainable.jpg",
    desc: "Take a guided tour of our farm and discover how we live in harmony with nature, from waste reduction to renewable energy.",
    video: "/public/sustainable.mp4"
  },
  {
    title: "Community & Togetherness",
    img: "/puja.jpg",
    desc: "Join us for family pujas, group activities, and shared meals that celebrate togetherness and gratitude on the farm.",
    video: "/public/puja.mp4"
  },
  {
    title: "Experience Gau Puja as a Family",
    img: "/gopuja.jpg",
    desc: "Take part in the sacred Gau Puja ritual as a family, offering prayers and gratitude to the cows in a meaningful, shared experience.",
    video: "/public/gopuja.mp4"
  },
  {
    title: "Taste the Season",
    img: "/taste_season.jpg", // updated image path
    desc: "Savor fresh, seasonal produce and traditional recipes made from the bounty of our farm. Experience the true flavors of each season!",
    video: "/public/taste.mp4" // update with your actual video path
  }
]

const selectedIdx = ref(null)
const selectedActivity = computed(() =>
  selectedIdx.value !== null ? activities[selectedIdx.value] : null
)

function selectActivity(idx) {
  selectedIdx.value = idx
}

// For scrapbook look: alternate rotations
function polaroidRotation(idx) {
  return idx % 2 === 0 ? 'rotate-[-3deg]' : 'rotate-[2deg]'
}
</script>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.4s;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>