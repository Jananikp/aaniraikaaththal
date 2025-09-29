<template>
  <div class="home-container" :style="{ paddingTop: navbarHeight + 'px' }">
    <!-- Horizontal scroll for the 3 hero/home panels -->
    <div
      class="horizontal-scroll-container"
      ref="scrollContainer"
      :style="{ scrollPaddingTop: navbarHeight + 'px' }"
    >
      <div class="horizontal-scroll-content">

        <!-- Section 1: Who We Are (text first, media right) -->
        <section class="horizontal-section bg-gradient-to-br from-amber-100 to-yellow-100 px-4 py-10 md:px-8 md:py-16">
          <div class="section-content flex flex-col md:flex-row items-start gap-6 md:gap-12 w-full">
            <!-- Text -->
            <div class="w-full md:w-1/2 flex flex-col justify-center items-center md:items-start text-center md:text-left">
              <h2 class="text-2xl md:text-3xl font-bold mb-4 text-green-700">Who We Are</h2>
              <p class="text-base md:text-lg leading-relaxed text-black">
                At Aannirai Kaathal, our mission is to protect indigenous cow breeds,
                not as commodities but as gentle, sentient members of our extended family.
                These cows live their full lives in peace — free from exploitation, only love, care, and reverence.
              </p>
            </div>

            <!-- Media (image) -->
            <div class="w-full md:w-1/2 flex justify-center items-center">
              <img
                :src="img1"
                alt="Who We Are"
                class="rounded-xl shadow-lg w-full h-auto max-w-full"
              />
            </div>
          </div>
        </section>

        <!-- Section 2: Care for Cows as Seva (text first, video right) -->
        <section class="horizontal-section bg-gradient-to-br from-amber-100 to-yellow-100 px-4 py-10 md:px-8 md:py-16">
          <div class="section-content flex flex-col md:flex-row items-start gap-6 md:gap-12 w-full">
            <!-- Text -->
            <div class="w-full md:w-1/2 flex flex-col justify-center items-center md:items-start text-center md:text-left">
              <h2 class="text-2xl md:text-3xl font-bold mb-4 text-green-700">Care for Cows as Seva</h2>
              <transition name="fade" mode="out-in">
                <p :key="currentSevaText" class="text-base md:text-lg leading-relaxed text-black">
                  {{ currentSevaText }}
                </p>
              </transition>
            </div>

            <!-- Video -->
            <div class="w-full md:w-1/2 flex justify-center items-center">
              <video
                ref="sevaVideo"
                :src="sevaSrc"
                autoplay
                muted
                loop
                playsinline
                preload="metadata"
                class="rounded-xl shadow-lg w-full h-auto max-w-full"
                @canplay="onSevaCanPlay"
                @timeupdate="onSevaTimeUpdate"
              >
                <!-- fallback source tag for browsers -->
                <source :src="sevaSrc" type="video/mp4" />
                Your browser does not support the video tag.
              </video>
            </div>
          </div>
        </section>

        <!-- Section 3: Friday Puja (text first, video right) -->
        <section class="horizontal-section bg-gradient-to-br from-amber-100 to-yellow-100 px-4 py-10 md:px-8 md:py-16">
          <div class="section-content flex flex-col md:flex-row items-start gap-6 md:gap-12 w-full">
            <!-- Text -->
            <div class="w-full md:w-1/2 flex flex-col justify-center items-center md:items-start text-center md:text-left">
              <h2 class="text-2xl md:text-3xl font-bold mb-4 text-green-700">Friday Puja</h2>
              <p class="text-base md:text-lg leading-relaxed text-black">
                Every Friday we gather for Gau Puja and offer our gratitude to the cows for their nourishment and blessings.
              </p>
            </div>

            <!-- Video -->
            <div class="w-full md:w-1/2 flex justify-center items-center">
              <video
                ref="video6"
                :src="fridaySrc"
                autoplay
                muted
                loop
                playsinline
                preload="metadata"
                class="rounded-xl shadow-lg w-full h-auto max-w-full"
              >
                <source :src="fridaySrc" type="video/mp4" />
                Your browser does not support the video tag.
              </video>
            </div>
          </div>
        </section>

      </div>
    </div>

    <!-- Vertical stacked sections (you said these are already fixed) -->
    <OurCows id="our-cows" />
    <DailyActivities id="daily-activities" />
    <Community id="community" />
    <GetInvolved id="get-involved" />
    <Contact id="contact" />

    <!-- Subscribe popup (unchanged) -->
    <div v-if="showSubscribe" class="fixed top-4 left-1/2 -translate-x-1/2 z-50">
      <div class="bg-white/95 border border-gray-200 rounded-xl shadow-xl w-[320px] md:w-[420px] p-4 md:p-5">
        <h3 class="text-xl font-semibold text-gray-900 mb-2">Stay Updated</h3>
        <p class="text-gray-700 mb-4">Subscribe to our notifications for the latest news and updates.</p>
        <div class="flex justify-end gap-2">
          <button @click="onLaterClick" class="px-3 py-1.5 rounded-lg border border-gray-300 text-gray-700 hover:bg-gray-50">Later</button>
          <button @click="onSubscribeClick" class="px-3 py-1.5 rounded-lg bg-green-600 text-white hover:bg-green-700">Subscribe</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import GetInvolved from './GetInvolved.vue'
import OurCows from './OurCows.vue'
import DailyActivities from './DailyActivitiesWheel.vue'
import Community from './Community.vue'
import Contact from './Contact.vue'

/*
  Media reference approach:
  - Option A (recommended for Vite): put large media in /public and reference with leading slash:
      /seva.mp4  /friday_puja.mp4  /image1.jpeg
  - Option B (bundle into build): import media from src/assets:
      import sevaSrc from '../assets/seva.mp4'
      and then use :src="sevaSrc"
*/

// Public-path (simple and works on dev and production if files sit in /public)
const img1 = '/image1.jpeg'
const sevaSrc = '/seva.mp4'
const fridaySrc = '/friday_puja.mp4'

// If you prefer bundling, uncomment and use the imports instead:
// import img1 from '../assets/image1.jpeg'
// import sevaSrc from '../assets/seva.mp4'
// import fridaySrc from '../assets/friday_puja.mp4'

const scrollContainer = ref(null)
const video6 = ref(null)
const sevaVideo = ref(null)
const sectionDurations = ref([0, 0, 0])
let scrollInterval = null
let currentSectionIndex = 0
const showSubscribe = ref(false)

// dynamic navbar height so the fixed navbar doesn't overlap content
const navbarHeight = ref(80) // fallback
onMounted(() => {
  const nav = document.querySelector('.navbar')
  if (nav) navbarHeight.value = nav.offsetHeight || navbarHeight.value

  // start auto-scroll timing (uses video durations when available)
  getVideoDuration(video6, 2).then(startAutoScroll)

  const videoObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        const vid = entry.target
        if (entry.isIntersecting) vid.play().catch(()=>{})
        else vid.pause()
      })
    },
    { threshold: 0.3 }
  )
  if (video6.value) videoObserver.observe(video6.value)
  if (sevaVideo.value) videoObserver.observe(sevaVideo.value)
})

onUnmounted(() => {
  if (scrollInterval) clearTimeout(scrollInterval)
})

/* Seva descriptions (timed) */
const sevaDescriptions = [
  { text: 'Keeping the shelter clean is our first act of seva — ensuring cows live in a pure, calm, and sacred environment.', start: 0, end: 4 },
  { text: 'Wholesome, natural fodder for our Indian native cows, prepared in the traditional way to keep them thriving.' },
  { text: 'We light sambrani just as it is offered in temples — to purify the air, ward off insects, and create a divine atmosphere.', start: 4, end: 7 },
  { text: 'Our cows spend their time grazing freely on natural pastures — happy, relaxed, and connected with nature.', start: 7, end: 10 },
  { text: 'Just like a family rushes to care for a loved one, veterinary doctors are always by our cows’ side — giving them immediate care and comfort whenever they fall sick.', start: 10, end: 15 },
  { text: 'Every calf is nurtured with love and protected as part of our family — the beginning of a life in care, not exploitation.', start: 15, end: 18 }
]
const currentSevaText = ref(sevaDescriptions[0].text)

function onSevaTimeUpdate(e) {
  const t = e.target.currentTime
  const desc = sevaDescriptions.find(d => d.start !== undefined && t >= d.start && t < d.end)
  if (desc && currentSevaText.value !== desc.text) currentSevaText.value = desc.text
}
function onSevaCanPlay(e){ if (e.target.paused) e.target.play().catch(()=>{}) }

/* video duration helpers for autoscroll */
function getVideoDuration(videoRef, sectionIndex) {
  return new Promise((resolve) => {
    if (videoRef.value) {
      const v = videoRef.value
      if (v.readyState >= 2) {
        sectionDurations.value[sectionIndex] = v.duration * 1000
        resolve()
      } else {
        v.addEventListener('loadedmetadata', () => {
          sectionDurations.value[sectionIndex] = v.duration * 1000
          resolve()
        }, { once: true })
      }
    } else resolve()
  })
}
function startAutoScroll() { scheduleNextScroll() }
function scheduleNextScroll() {
  if (!scrollContainer.value) return
  const container = scrollContainer.value
  const scrollWidth = container.scrollWidth
  const clientWidth = container.clientWidth
  const currentScroll = container.scrollLeft
  const currentDuration = sectionDurations.value[currentSectionIndex] || 8000

  scrollInterval = setTimeout(() => {
    if (currentScroll >= scrollWidth - clientWidth) {
      container.scrollTo({ left: 0, behavior: 'smooth' })
      currentSectionIndex = 0
    } else {
      const nextScroll = Math.min(currentScroll + clientWidth, scrollWidth - clientWidth)
      container.scrollTo({ left: nextScroll, behavior: 'smooth' })
      currentSectionIndex++
    }
    scheduleNextScroll()
  }, currentDuration)
}

/* subscribe popup */
function onLaterClick(){ showSubscribe.value = false }
async function onSubscribeClick(){
  try { if ('Notification' in window && Notification.requestPermission) await Notification.requestPermission() } catch(e){}
  localStorage.setItem('subscribePromptDisabled','1')
  showSubscribe.value = false
}
</script>

<style scoped>
/* container accounts for fixed navbar */
.home-container {
  width: 100%;
  box-sizing: border-box;
}

/* Horizontal hero strip */
.horizontal-scroll-container {
  width: 100vw;
  overflow-x: auto;
  overflow-y: hidden;
  scroll-snap-type: x mandatory;
  scroll-behavior: smooth;
}

.horizontal-scroll-content {
  display: flex;
  width: max-content;
  /* allow content to size naturally (no forced height) */
}

.horizontal-section {
  width: 100vw;
  flex-shrink: 0;
  scroll-snap-align: start;
  display: flex;
  justify-content: center;
  padding: 2rem;
  box-sizing: border-box;
}

.section-content {
  max-width: 1200px;
  width: 100%;
  display: flex;
}

/* Videos & images scale naturally */
.horizontal-section video,
.horizontal-section img {
  object-fit: contain;
  width: 100%;
  height: auto;
  border-radius: 0.75rem;
}

/* fade transition for seva text */
.fade-enter-active, .fade-leave-active { transition: opacity 0.7s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

/* hide scrollbar visual on WebKit */
.horizontal-scroll-container::-webkit-scrollbar { display: none; }
.horizontal-scroll-container { scrollbar-width: none; }

/* Responsive: text-first (stack) on small screens */
@media (max-width: 767px) {
  .section-content { flex-direction: column; text-align: center; }
  .section-content > div { width: 100%; margin-bottom: 1rem; }
  .horizontal-section { padding: 1.5rem; }
}
</style>
