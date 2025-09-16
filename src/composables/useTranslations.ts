import { computed } from 'vue'
import { useLanguageStore } from '../stores/language'

export function useLanguage() {
  const languageStore = useLanguageStore()
  
  const currentLanguage = computed(() => languageStore.currentLanguage)
  
  return {
    currentLanguage
  }
}

