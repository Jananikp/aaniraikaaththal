<template>
    <div class="horizontal-scroll-container" ref="scrollContainer">
      <div class="horizontal-scroll-content">
  
              <!-- Section 1 (Who We Are) -->
      <section class="horizontal-section bg-gradient-to-br from-amber-100 to-yellow-100 px-2 py-8 md:px-8 md:py-16">
        <div class="section-content flex flex-col md:flex-row items-center gap-6 md:gap-12 w-full h-full">
          <!-- Media Left -->
          <div class="w-full md:w-1/2 flex flex-col items-center">
            <img src="/image1.jpeg" alt="Who We Are" class="rounded-xl shadow-lg w-full max-w-full aspect-video max-h-[60vw] md:max-h-[400px] object-cover mb-4" />
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
  
              <!-- Section: Care for cows as seva (single video, timed descriptions with fade) -->
      <section class="horizontal-section bg-gradient-to-br from-amber-100 to-yellow-100 px-2 py-8 md:px-8 md:py-16">
        <div class="section-content flex flex-col md:flex-row items-center gap-6 md:gap-12 w-full h-full">
          <!-- Media Left -->
          <div class="w-full md:w-1/2 flex flex-col items-center">
            <video
              ref="sevaVideo"
              src="/seva.mp4"
              controls
              autoplay
              muted
              playsinline
              class="rounded-xl shadow-lg w-full max-w-full aspect-video max-h-[60vw] md:max-h-[400px] mb-4 object-cover"
              @canplay="onSevaCanPlay"
              @timeupdate="onSevaTimeUpdate"
            ></video>
          </div>
          <!-- Description Right -->
          <div class="w-full md:w-1/2 flex flex-col justify-center items-center md:items-start text-center md:text-left">
            <h2 class="text-2xl md:text-3xl font-bold mb-4 text-green-700">Care for cows as seva</h2>
            <transition name="fade" mode="out-in">
              <p class="text-base md:text-lg leading-relaxed text-black min-h-[5rem] px-2 md:px-0" :key="currentSevaText">
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
                src="/friday_puja.mp4" 
                autoplay muted loop playsinline 
                ref="video6"
                class="rounded-xl shadow-lg w-full max-w-full aspect-video max-h-[60vw] md:max-h-[400px] object-cover mb-4">
              </video>
            </div>
            <!-- Description Right -->
            <div class="w-full md:w-1/2 flex flex-col justify-center items-center md:items-start text-center md:text-left">
              <h2 class="text-2xl md:text-3xl font-bold mb-4 text-green-700">{{ t.section5Title }}</h2>
              <p class="text-base md:text-lg leading-relaxed text-black min-h-[5rem] px-2 md:px-0">
                {{ t.section5Description }}
              </p>
            </div>
          </div>
        </section>
    
      </div>
      <!-- Subscribe Popup -->
      <div v-if="showSubscribe" class="fixed top-4 left-1/2 -translate-x-1/2 z-50">
        <div class="bg-white/95 border border-gray-200 rounded-xl shadow-xl w-[320px] md:w-[420px] p-4 md:p-5">
          <h3 class="text-xl font-semibold text-gray-900 mb-2">Stay Updated</h3>
          <p class="text-gray-700 mb-4">Subscribe to our notifications for the latest news and updates. You can disable anytime.</p>
          <div class="flex justify-end gap-2">
            <button @click="onLaterClick" class="px-3 py-1.5 rounded-lg border border-gray-300 text-gray-700 hover:bg-gray-50">Later</button>
            <button @click="onSubscribeClick" class="px-3 py-1.5 rounded-lg bg-green-600 text-white hover:bg-green-700">Subscribe</button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue'
  
  // refs for video autoplay when in viewport
  const video2 = ref(null)
  const video3 = ref(null)
  const video4b = ref(null)
  const video6 = ref(null)
  const scrollContainer = ref(null)
  const sectionDurations = ref([0, 0, 0, 0, 0, 0]) // Store duration for each section
  let scrollInterval
  let currentSectionIndex = 0
  const showSubscribe = ref(false)
  
  const sevas = [
    { video: '/seva1.mp4', text: 'text1' },
    { video: '/seva2.mp4', text: 'text2' },
    { video: '/seva3.mp4', text: 'text3' },
    { video: '/seva4.mp4', text: 'text4' },
    { video: '/seva5.mp4', text: 'text5' }
  ]
  const currentSeva = ref(0)
  const sevaVideo = ref(null)
  let allSevaVideosPlayed = false;

  onMounted(() => {
    // Wait for videos to load and get their durations
    Promise.all([
      getVideoDuration(video2, 1),
      getVideoDuration(video3, 2), 
      getVideoDuration(video4b, 3),
      getVideoDuration(video6, 5)
    ]).then(() => {
      // Start auto-scroll after all durations are loaded
      startAutoScroll()
    })

    const videoObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          const video = entry.target
          if (entry.isIntersecting) {
            video.play().catch(() => {})
          } else {
            video.pause()
          }
        })
      },
      { threshold: 0.3 }
    )
  
    if (video2.value) videoObserver.observe(video2.value)
    if (video3.value) videoObserver.observe(video3.value)
    if (video4b.value) videoObserver.observe(video4b.value)
    if (video6.value) videoObserver.observe(video6.value)
    
    // No slideshow for Section 4; single looping video
  })
  
  onUnmounted(() => {
    if (scrollInterval) {
      clearTimeout(scrollInterval)
    }
  })
  
  function getVideoDuration(videoRef, sectionIndex) {
    return new Promise((resolve) => {
      if (videoRef.value) {
        const video = videoRef.value
        if (video.readyState >= 2) { // HAVE_CURRENT_DATA
          sectionDurations.value[sectionIndex] = video.duration * 1000 // Convert to milliseconds
          resolve()
        } else {
          video.addEventListener('loadedmetadata', () => {
            sectionDurations.value[sectionIndex] = video.duration * 1000
            resolve()
          })
        }
      } else {
        resolve()
      }
    })
  }

  function startAutoScroll() {
    // Schedule next section scroll based on current section's video duration
    scheduleNextScroll()
  }

  function scheduleNextScroll() {
    if (scrollContainer.value) {
      const container = scrollContainer.value;
      const scrollWidth = container.scrollWidth;
      const clientWidth = container.clientWidth;
      const currentScroll = container.scrollLeft;
      // Get duration for current section (default to 8 seconds if no video)
      let currentDuration = sectionDurations.value[currentSectionIndex] || 8000;
      // If on Care for cows as seva section, wait for all videos
      if (currentSectionIndex === 3 && !allSevaVideosPlayed) {
        // Wait for all videos to play before transitioning
        currentDuration = null;
      }
      if (currentDuration !== null) {
        scrollInterval = window.setTimeout(() => {
          // If we've reached the end, scroll back to the beginning
          if (currentScroll >= scrollWidth - clientWidth) {
            // Trigger subscribe popup once per session if not disabled
            const disabled = localStorage.getItem('subscribePromptDisabled') === '1'
            const shownThisSession = sessionStorage.getItem('subscribePromptShown') === '1'
            if (!disabled && !shownThisSession) {
              showSubscribe.value = true
              sessionStorage.setItem('subscribePromptShown', '1')
            }
            container.scrollTo({ left: 0, behavior: 'smooth' });
            currentSectionIndex = 0;
          } else {
            // Scroll to the next section
            const sectionWidth = clientWidth;
            const nextScroll = Math.min(currentScroll + sectionWidth, scrollWidth - clientWidth);
            container.scrollTo({ left: nextScroll, behavior: 'smooth' });
            currentSectionIndex++;
          }
          // Schedule next scroll
          scheduleNextScroll();
        }, currentDuration);
      }
    }
  }

  function onLaterClick() {
    showSubscribe.value = false
  }

  async function onSubscribeClick() {
    try {
      if ('Notification' in window && Notification.requestPermission) {
        await Notification.requestPermission()
      }
    } catch (e) {
      // ignore
    }
    // Do not show again automatically in future visits
    localStorage.setItem('subscribePromptDisabled', '1')
    showSubscribe.value = false
  }
  
  function nextSeva() {
    if (currentSeva.value < sevas.length - 1) {
      currentSeva.value++;
    } else {
      allSevaVideosPlayed = true;
    }
  }
  function goToSeva(idx) {
    currentSeva.value = idx;
  }
  // Ensure autoplay on video change
  watch(currentSeva, () => {
    if (sevaVideo.value) {
      sevaVideo.value.load();
      sevaVideo.value.play();
    }
  })

  // Patch auto-scroll logic to not transition to next section until all seva videos played
  watch(() => allSevaVideosPlayed, (val) => {
    if (val) {
      // Resume auto-scroll after a short delay
      setTimeout(() => {
        if (scrollContainer.value) {
          const container = scrollContainer.value;
          const sectionWidth = container.clientWidth;
          const nextScroll = container.scrollLeft + sectionWidth;
          container.scrollTo({ left: nextScroll, behavior: 'smooth' });
          currentSectionIndex++;
          scheduleNextScroll();
        }
      }, 1000);
    }
  });
  const sevaDescriptions = [
    { text: 'Keeping the shelter clean is our first act of seva — ensuring cows live in a pure, calm, and sacred environment.', start: 0, end: 4 },
    { text: 'We light sambrani just as it is offered in temples — to purify the air, ward off insects, and create a divine atmosphere.This act, rooted in our tradition, keeps the cows calm and brings the same sense of sanctity one feels inside a temple.', start: 4, end: 7 },
    { text: 'Our cows spend their time grazing freely on natural pastures — happy, relaxed, and connected with nature.', start: 7, end: 9 },
    { text: 'Just like a family rushes to care for a loved one, veterinary doctors are always by our cows’ side — giving them immediate care and comfort whenever they fall sick.', start: 9, end: 13 },
    { text: 'Every calf is nurtured with love and protected as part of our family — the beginning of a life in care, not exploitation.', start: 13, end: 18 }
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
    // Try to play the video programmatically (for browsers that block autoplay with sound)
    if (e.target.paused) {
      e.target.play().catch(() => {})
    }
  }
  </script>
  
  <script>
  /* Custom directive for fade/slide in */
  export default {
    directives: {
      intersect: {
        mounted(el) {
          const observer = new IntersectionObserver(
            ([entry]) => {
              if (entry.isIntersecting) {
                el.classList.remove(
                  'opacity-0', 'translate-y-8', '-translate-x-8', 'translate-x-8', 'scale-90'
                )
                el.classList.add(
                  'opacity-100', 'translate-y-0', 'translate-x-0', 'scale-100'
                )
                observer.unobserve(el)
              }
            },
            { threshold: 0.2 }
          )
          observer.observe(el)
        }
      }
    }
  }
  </script>
  
  <style>
  /* Horizontal scrolling container */
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
  
  /* Zoom-in effect for Section 5 */
  @keyframes zoomInSlow {
    from {
      transform: scale(0.8);
    }
    to {
      transform: scale(0.9);
    }
  }
  .animate-zoom {
    animation: zoomInSlow 20s ease-in-out forwards;
  }
  
  /* Hide scrollbar for webkit browsers */
  .horizontal-scroll-container::-webkit-scrollbar {
    display: none;
  }
  
  /* Hide scrollbar for Firefox */
  .horizontal-scroll-container {
    scrollbar-width: none;
  }
  .fade-enter-active, .fade-leave-active {
    transition: opacity 0.7s;
  }
  .fade-enter-from, .fade-leave-to {
    opacity: 0;
  }
  </style>
