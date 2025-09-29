import { createApp } from 'vue'
import { createPinia } from 'pinia'
import './style.css'
import App from './App.vue'
import { useLanguageStore } from './stores/language'
import router from './router'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)

// Initialize language store
const languageStore = useLanguageStore()
languageStore.initializeLanguage()

app.mount('#app')
