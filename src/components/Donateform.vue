<template>
  <div class="min-h-screen bg-gradient-to-br from-amber-100 to-yellow-100 flex items-center justify-center py-12 px-4">
    <div class="bg-white/90 rounded-2xl shadow-xl p-8 max-w-md w-full flex flex-col items-center">
      <!-- Logo or Trust Seal -->
      <img src="/aanirailogo.png" alt="Aanirai Kaaththal" class="h-20 mb-4 rounded-lg shadow" />
      <template v-if="!submitted">
        <h2 class="text-2xl font-bold mb-2 text-green-800 font-sans">Support Aanirai Kaaththal</h2>
        <p class="text-green-900 mb-6 text-center font-sans">
          Your donation helps us care for our cows and sustain our seva.<br>
          All contributions are tax exempt under 80G.
        </p>
        <form class="w-full space-y-4" @submit="handleSubmit">
          <div>
            <label class="block text-green-900 font-semibold mb-1 font-sans">Name</label>
            <input v-model="name" type="text" class="w-full border border-green-200 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-green-400 font-sans text-gray-900" placeholder="Your Name" />
            <p v-if="errors.name" class="text-red-600 text-xs mt-1">{{ errors.name }}</p>
          </div>
          <div>
            <label class="block text-green-900 font-semibold mb-1 font-sans">Email</label>
            <input v-model="email" type="email" class="w-full border border-green-200 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-green-400 font-sans text-gray-900" placeholder="you@email.com" />
            <p v-if="errors.email" class="text-red-600 text-xs mt-1">{{ errors.email }}</p>
          </div>
          <div>
            <label class="block text-green-900 font-semibold mb-1 font-sans">Mobile Number</label>
            <div class="flex">
              <select v-model="countryCode" class="border border-green-200 rounded-l px-2 py-2 bg-white font-sans text-gray-900">
                <option value="+91">+91</option>
                <option value="+1">+1</option>
                <option value="+44">+44</option>
                <!-- Add more as needed -->
              </select>
              <input v-model="mobile" type="tel" class="w-full border-t border-b border-r border-green-200 rounded-r px-3 py-2 focus:outline-none focus:ring-2 focus:ring-green-400 font-sans text-gray-900" placeholder="Mobile Number" />
            </div>
            <p v-if="errors.mobile" class="text-red-600 text-xs mt-1">{{ errors.mobile }}</p>
          </div>
          <div>
            <label class="block text-green-900 font-semibold mb-1 font-sans">Amount (INR)</label>
            <input v-model="amount" type="number" class="w-full border border-green-200 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-green-400 font-sans text-gray-900" placeholder="Amount" />
          </div>
          <div>
            <label class="block text-green-900 font-semibold mb-1 font-sans">PAN</label>
            <p class="text-xs text-gray-700 mb-1">(optional; required if you wish to claim 80G tax exemption)</p>
            <input v-model="pan" type="text" class="w-full border border-green-200 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-green-400 font-sans text-gray-900 uppercase" placeholder="PAN Number" maxlength="10" />
            <p v-if="errors.pan" class="text-red-600 text-xs mt-1">{{ errors.pan }}</p>
          </div>
          <button type="submit" class="w-full bg-green-700 text-white font-bold py-2 rounded-lg mt-4 hover:bg-green-800 transition font-sans">
            Submit
          </button>
        </form>
      </template>
      <template v-else>
        <div class="text-center py-8">
          <p class="text-green-800 text-lg font-semibold mb-4">Thank you. We have received your details.</p>
          <p class="text-gray-700">
            Unlike instant online transfers, we follow a personal, trust-driven process for donations.<br>
            Our team will connect with you directly over phone or email to share secure payment details.
          </p>
        </div>
      </template>
      <!-- Authentic Cow Image -->
      <img src="/feeding.jpg" alt="Cow Seva" class="w-32 mt-6 rounded shadow-md opacity-80" />
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const submitted = ref(false)
const name = ref('')
const email = ref('')
const countryCode = ref('+91')
const mobile = ref('')
const amount = ref('')
const pan = ref('')

const errors = ref({
  name: '',
  email: '',
  mobile: '',
  pan: ''
})

function validateEmail(val) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)
}
function validateMobile(val) {
  // Accepts 10-15 digits, no spaces, no letters
  return /^[0-9]{10,15}$/.test(val)
}
function validatePAN(val) {
  // 5 letters, 4 digits, 1 letter (uppercase)
  return /^[A-Z]{5}[0-9]{4}[A-Z]{1}$/.test(val.toUpperCase())
}

function handleSubmit(e) {
  e.preventDefault()
  errors.value = { name: '', email: '', mobile: '', pan: '' }
  let valid = true
  if (!name.value.trim()) {
    errors.value.name = 'Name is required.'
    valid = false
  }
  if (!email.value.trim() || !validateEmail(email.value)) {
    errors.value.email = 'Valid email is required.'
    valid = false
  }
  if (!mobile.value.trim() || !validateMobile(mobile.value)) {
    errors.value.mobile = 'Enter a valid mobile number (10-15 digits).'
    valid = false
  }
  if (pan.value && !validatePAN(pan.value)) {
    errors.value.pan = 'Invalid PAN format. Example: ABCDE1234F'
    valid = false
  }
  if (valid) {
    submitted.value = true
  }
}
</script>