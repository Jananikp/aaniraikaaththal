<!-- filepath: /Users/janani/Downloads/aghnyatrust/src/components/GetInvolved.vue -->
<template>
  <section id="get-involved" class="py-16 md:py-20 px-4 md:px-6 bg-gradient-to-br from-amber-100 to-yellow-100 min-h-screen">
    <div class="max-w-4xl mx-auto bg-[#FFF8DC] rounded-xl shadow-md p-8">
      <h2 class="text-2xl md:text-3xl font-bold text-green-700 mb-4 text-center">Get Involved</h2>
      <p class="text-lg text-gray-700 mb-6 text-center">
        Tax exempted under section 80G(5)(iii) of Income tax vide registration No
      </p>
       <div class="flex justify-center mb-8">
    <button @click="scrollToDonateOptions" style="color: white;">
      Donate
    </button>
  </div>
      <section id="donate-options" class="my-12">
        <h3 class="text-xl font-bold text-green-700 mb-6 text-center">Choose Your Donation</h3>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div id="monthly-care" class="bg-green-50 p-6 rounded-xl shadow text-center">
            <h4 class="text-lg font-semibold text-green-700 mb-2">Monthly Care</h4>
            <p class="text-gray-700">Support the monthly care of our cows.</p>
          </div>
          <div id="fodder-seva" class="bg-green-50 p-6 rounded-xl shadow text-center">
            <h4 class="text-lg font-semibold text-green-700 mb-2">Fodder Seva</h4>
            <p class="text-gray-700">Contribute towards nutritious fodder for the herd.</p>
          </div>
          <div id="any-amount" class="bg-green-50 p-6 rounded-xl shadow text-center">
            <h4 class="text-lg font-semibold text-green-700 mb-2">Any Amount Choice</h4>
            <p class="text-gray-700">Donate any amount of your choice.</p>
          </div>
        </div>
        <div class="flex justify-center mt-8">
          <router-link to="/donate">
            <button class="bg-green-700 hover:bg-green-800 text-white font-semibold py-2 px-6 rounded-lg shadow transition">
              Go to Donate Form
            </button>
          </router-link>
        </div>
      </section>
    </div>
  </section>
</template>

<script setup>
function scrollToDonateOptions() {
  const el = document.getElementById('donate-options');
  if (el) {
    el.scrollIntoView({ behavior: 'smooth' });
  }
}
</script>