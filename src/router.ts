import { createRouter, createWebHistory } from 'vue-router'
import HomePage from './components/HomePage.vue'
import GetInvolved from './components/GetInvolved.vue'
import OurCows from './components/OurCows.vue'
import Donateform from './components/Donateform.vue'
import DailyActivitiesWheel from './components/DailyActivitiesWheel.vue'
import Community from './components/Community.vue'
import Contact from './components/Contact.vue'

const routes = [
  {
    path: '/',
    component: HomePage
  },
  {
    path: '/get-involved',
    component: GetInvolved
  },
  {
    path: '/our-cows',
    component: OurCows
  },
  {
    path: '/donate',
    name: 'Donateform',
    component: Donateform
  },
  {
    path: '/daily-activities',
    component: DailyActivitiesWheel
  },
  {
    path: '/community',
    component: Community
  },
  {
    path: '/contact',
    component: Contact
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
