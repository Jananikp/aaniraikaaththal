import { defineStore } from 'pinia'

export const useLanguageStore = defineStore('language', {
  state: () => ({
    currentLanguage: 'en' // Default to English
  }),
  
  actions: {
    setLanguage(languageCode: string) {
      this.currentLanguage = languageCode
      // Store in localStorage for persistence
      localStorage.setItem('selectedLanguage', languageCode)
    },
    
    initializeLanguage() {
      // Load saved language preference from localStorage
      const savedLanguage = localStorage.getItem('selectedLanguage')
      if (savedLanguage) {
        this.currentLanguage = savedLanguage
      }
    }
  },
  
  getters: {
    isEnglish: (state) => state.currentLanguage === 'en',
    isTamil: (state) => state.currentLanguage === 'ta',
    isHindi: (state) => state.currentLanguage === 'hi'
  }
})

