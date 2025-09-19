<template>
  <div class="horizontal-scroll-container" ref="scrollContainer">
    <div class="horizontal-scroll-content">
      <!-- Section 1 (Who We Are) -->
      <section class="horizontal-section bg-gradient-to-br from-amber-100 to-yellow-100 px-2 py-8 md:px-8 md:py-16">
        <div class="section-content flex flex-col md:flex-row items-center gap-6 md:gap-12 w-full h-full">
          <!-- Media Left -->
          <div class="w-full md:w-1/2 flex flex-col items-center">
            <img
              src="/image1.jpeg"
              alt="Who We Are"
              class="rounded-xl shadow-lg w-full max-w-full aspect-video max-h-[60vw] md:max-h-[400px] object-cover mb-4"
            />
          </div>
          <!-- Description Right -->
          <div class="w-full md:w-1/2 flex flex-col justify-center items-center md:items-start text-center md:text-left">
            <h2 class="text-2xl md:text-3xl font-bold mb-4 text-green-700">Who We Are</h2>
            <p class="text-base md:text-lg leading-relaxed text-black min-h-[5rem] px-2 md:px-0">
              At Aannirai Kaathal, our mission is to protect indigenous cow breeds,
              not as commodities but as gentle, sentient members of our extended family.
              These cows live their full lives in peace — free from exploitation,
              only love, care, and reverence.
            </p>
          </div>
        </div>
      </section>

      <!-- Section 5 (Care for cows as seva - single video with timed text) -->
      <section class="horizontal-section bg-gradient-to-br from-amber-100 to-yellow-100 px-2 py-8 md:px-8 md:py-16">
        <div class="section-content flex flex-col md:flex-row items-center gap-6 md:gap-12 w-full h-full">
          <!-- Video Left -->
          <div class="w-full md:w-1/2 flex flex-col items-center">
            <video
              ref="sevaVideo"
              src="/seva.mp4"
              autoplay
              muted
              loop
              playsinline
              class="rounded-xl shadow-lg w-full max-w-full aspect-video max-h-[60vw] md:max-h-[400px] object-cover"
              @canplay="onSevaCanPlay"
              @timeupdate="onSevaTimeUpdate"
            ></video>
          </div>
          <!-- Description Right -->
          <div class="w-full md:w-1/2 flex flex-col justify-center items-center md:items-start text-center md:text-left">
            <h2 class="text-2xl md:text-3xl font-bold mb-4 text-green-700">Care for Cows as Seva</h2>
            <transition name="fade" mode="out-in">
              <p
                :key="currentSevaText"
                class="text-base md:text-lg leading-relaxed text-black min-h-[5rem] px-2 md:px-0"
              >
                {{ currentSevaText }}
              </p>
            </transition>
          </div>
        </div>
      </section>

      <!-- Section 6 (Friday Puja & Blessings) -->
      <section class="horizontal-section bg-gradient-to-br from-amber-100 to-yellow-100 px-2 py-8 md:px-8 md:py-16">
        <div class="section-content flex flex-col md:flex-row items-center gap-6 md:gap-12 w-full h-full">
          <!-- Media Left -->
          <div class="w-full md:w-1/2 flex flex-col items-center">
            <video
              ref="video6"
              src="/friday_puja.mp4"
              autoplay
              muted
              loop
              playsinline
              class="rounded-xl shadow-lg w-full max-w-full aspect-video max-h-[60vw] md:max-h-[400px] object-cover mb-4"
            ></video>
          </div>
          <!-- Description Right -->
          <div class="w-full md:w-1/2 flex flex-col justify-center items-center md:items-start text-center md:text-left">
            <h2 class="text-2xl md:text-3xl font-bold mb-4 text-green-700">Friday Puja</h2>
            <p class="text-base md:text-lg leading-relaxed text-black min-h-[5rem] px-2 md:px-0">
              Every Friday we gather for Gau Puja and offer our gratitude to the cows for their nourishment and blessings.
            </p>
          </div>
        </div>
      </section>
    </div>

    <!-- Subscribe Popup -->
    <div v-if="showSubscribe" class="fixed top-4 left-1/2 -translate-x-1/2 z-50">
      <div class="bg-white/95 border border-gray-200 rounded-xl shadow-xl w-[320px] md:w-[420px] p-4 md:p-5">
        <h3 class="text-xl font-semibold text-gray-900 mb-2">Stay Updated</h3>
        <p class="text-gray-700 mb-4">
          Subscribe to our notifications for the latest news and updates. You can disable anytime.
        </p>
        <div class="flex justify-end gap-2">
          <button @click="onLaterClick" class="px-3 py-1.5 rounded-lg border border-gray-300 text-gray-700 hover:bg-gray-50">
            Later
          </button>
          <button
            @click="onSubscribeClick"
            class="px-3 py-1.5 rounded-lg bg-green-600 text-white hover:bg-green-700"
          >
            Subscribe
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const scrollContainer = ref(null)
const video6 = ref(null)
const sevaVideo = ref(null)

const sectionDurations = ref([0, 0, 0]) // store section durations
let scrollInterval
let currentSectionIndex = 0
const showSubscribe = ref(false)

// Seva timed text
const sevaDescriptions = [
  { text: 'Keeping the shelter clean is our first act of seva — ensuring cows live in a pure, calm, and sacred environment.', start: 0, end: 4 },
  { text: 'Wholesome, natural fodder for our Indian native cows, prepared in the traditional way to keep them thriving. '},
  { text: 'We light sambrani just as it is offered in temples — to purify the air, ward off insects, and create a divine atmosphere. This act, rooted in our tradition, keeps the cows calm and brings the same sense of sanctity one feels inside a temple.', start: 4, end: 7 },
  { text: 'Our cows spend their time grazing freely on natural pastures — happy, relaxed, and connected with nature.', start: 7, end: 9 },
  { text: 'Just like a family rushes to care for a loved one, veterinary doctors are always by our cows’ side — giving them immediate care and comfort whenever they fall sick.', start: 9, end: 14 },
  { text: 'Every calf is nurtured with love and protected as part of our family — the beginning of a life in care, not exploitation.', start: 14, end: 18 }
]
const currentSevaText = ref(sevaDescriptions[0].text)

function onSevaTimeUpdate(e) {
  const t = e.target.currentTime
  const desc = sevaDescriptions.find(d => t >= d.start && t < d.end)
  if (desc && currentSevaText.value !== desc.text) {
    currentSevaText.value = desc.text
  }
}

function onSevaCanPlay(e) {
  if (e.target.paused) {
    e.target.play().catch(() => {})
  }
}

// Auto-scroll logic
onMounted(() => {
  getVideoDuration(video6, 2).then(startAutoScroll)

  const videoObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        const video = entry.target
        if (entry.isIntersecting) video.play().catch(() => {})
        else video.pause()
      })
    },
    { threshold: 0.3 }
  )

  if (video6.value) videoObserver.observe(video6.value)
})

onUnmounted(() => {
  if (scrollInterval) clearTimeout(scrollInterval)
})

function getVideoDuration(videoRef, sectionIndex) {
  return new Promise((resolve) => {
    if (videoRef.value) {
      const video = videoRef.value
      if (video.readyState >= 2) {
        sectionDurations.value[sectionIndex] = video.duration * 1000
        resolve()
      } else {
        video.addEventListener('loadedmetadata', () => {
          sectionDurations.value[sectionIndex] = video.duration * 1000
          resolve()
        })
      }
    } else resolve()
  })
}

function startAutoScroll() {
  scheduleNextScroll()
}

function scheduleNextScroll() {
  if (!scrollContainer.value) return
  const container = scrollContainer.value
  const scrollWidth = container.scrollWidth
  const clientWidth = container.clientWidth
  const currentScroll = container.scrollLeft

  const currentDuration = sectionDurations.value[currentSectionIndex] || 8000

  scrollInterval = setTimeout(() => {
    if (currentScroll >= scrollWidth - clientWidth) {
      const disabled = localStorage.getItem('subscribePromptDisabled') === '1'
      const shownThisSession = sessionStorage.getItem('subscribePromptShown') === '1'
      if (!disabled && !shownThisSession) {
        showSubscribe.value = true
        sessionStorage.setItem('subscribePromptShown', '1')
      }
      container.scrollTo({ left: 0, behavior: 'smooth' })
      currentSectionIndex = 0
    } else {
      const sectionWidth = clientWidth
      const nextScroll = Math.min(currentScroll + sectionWidth, scrollWidth - clientWidth)
      container.scrollTo({ left: nextScroll, behavior: 'smooth' })
      currentSectionIndex++
    }
    scheduleNextScroll()
  }, currentDuration)
}

function onLaterClick() {
  showSubscribe.value = false
}

async function onSubscribeClick() {
  try {
    if ('Notification' in window && Notification.requestPermission) {
      await Notification.requestPermission()
    }
  } catch (e) {}
  localStorage.setItem('subscribePromptDisabled', '1')
  showSubscribe.value = false
}
</script>

<style>
.horizontal-scroll-container {
  width: 100vw;
  height: 100vh;
  overflow-x: auto;
  overflow-y: hidden;
  scroll-snap-type: x mandatory;
  scroll-behavior: smooth;
}

.horizontal-scroll-content {
  display: flex;
  width: max-content;
  height: 100%;
}

.horizontal-section {
  width: 100vw;
  height: 100vh;
  flex-shrink: 0;
  scroll-snap-align: start;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
}

.section-content {
  max-width: 1200px;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.7s;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Hide scrollbar */
.horizontal-scroll-container::-webkit-scrollbar {
  display: none;
}
.horizontal-scroll-container {
  scrollbar-width: none;
}
</style>
