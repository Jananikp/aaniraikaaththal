<template>
  <div class="relative inline-block text-left">
    <!-- Language Toggle Button -->
    <button
      @click="isOpen = !isOpen"
      class="inline-flex items-center justify-center w-full px-4 py-2 text-sm font-medium text-white bg-green-700 border border-transparent rounded-md shadow-sm hover:bg-green-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
    >
      <span class="mr-2">{{ currentLanguage.flag }}</span>
      {{ currentLanguage.name }}
      <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
      </svg>
    </button>

    <!-- Dropdown Menu -->
    <div
      v-if="isOpen"
      class="absolute right-0 w-48 mt-2 origin-top-right bg-white border border-gray-200 divide-y divide-gray-100 rounded-md shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none z-50"
    >
      <div class="py-1">
        <button
          v-for="lang in languages"
          :key="lang.code"
          @click="selectLanguage(lang.code)"
          class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 hover:text-gray-900"
          :class="{ 'bg-green-50 text-green-700': lang.code === currentLanguage.code }"
        >
          <span class="mr-2">{{ lang.flag }}</span>
          {{ lang.name }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useLanguageStore } from '../stores/language'

const languageStore = useLanguageStore()
const isOpen = ref(false)

const languages = [
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'ta', name: 'தமிழ்', flag: '🇮🇳' },
  { code: 'hi', name: 'हिंदी', flag: '🇮🇳' }
]

const currentLanguage = computed(() => {
  return languages.find(lang => lang.code === languageStore.currentLanguage) || languages[0]
})

const selectLanguage = (languageCode) => {
  languageStore.setLanguage(languageCode)
  isOpen.value = false
}

// Close dropdown when clicking outside
const closeDropdown = (event) => {
  if (!event.target.closest('.relative')) {
    isOpen.value = false
  }
}

// Add click outside listener
onMounted(() => {
  document.addEventListener('click', closeDropdown)
})

onUnmounted(() => {
  document.removeEventListener('click', closeDropdown)
})
</script>

