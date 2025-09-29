<template>
  <nav class="navbar">
    <div class="navbar-container">
      <!-- Logo -->
      <div class="navbar-logo">
        <img
          src="/aanirailogo.png"
          alt="Aanirai Kaaththal"
          class="navbar-logo-img"
        />
        <router-link to="/" class="navbar-logo-text">
          Aanirai Kaaththal
        </router-link>
      </div>

      <!-- Center / Right area -->
      <div class="navbar-right">
        <!-- Desktop-only nav links -->
        <div class="navbar-links desktop-only">
          <router-link to="/" class="navbar-link">About Us</router-link>
          <router-link to="/our-cows" class="navbar-link">Our Cows</router-link>
          <router-link to="/daily-activities" class="navbar-link">Daily Activities</router-link>
          <router-link to="/community" class="navbar-link">Community</router-link>
          <router-link to="/get-involved" class="navbar-link">Get Involved</router-link>
          <router-link to="/contact" class="navbar-link">Contact</router-link>
        </div>

        <!-- Actions -->
        <div class="navbar-actions">
          <router-link to="/donate" class="btn-donate">Donate</router-link>

          <!-- Show login button if not logged in -->
          <button
            v-if="!isLoggedIn"
            class="btn-login"
            @click="showLogin = true"
          >
            Login
          </button>

          <!-- Show user initial if logged in -->
          <!-- <div v-else class="btn-login">
            {{ userInitial }}
          </div> -->
          <!-- Show user initial and logout button if logged in -->
<!-- <div v-else class="btn-login" style="cursor: pointer;" @click="handleLogout">
  {{ userInitial }}
</div> -->

 <!-- Show user initial with dropdown if logged in -->
          <div v-else class="user-dropdown">
            <div class="btn-login" @click="toggleDropdown">
              {{ userInitial }}
            </div>
            <div v-if="dropdownOpen" class="dropdown-menu">
              <button class="btn-logout" @click="handleLogout">Logout</button>
            </div>
          </div>

        </div>
      </div>
    </div>

    <!-- Login Modal -->
    <transition name="fade">
      <div
        v-if="showLogin"
        class="login-modal"
        @keydown.esc="showLogin = false"
      >
        <div class="login-box" role="dialog" aria-modal="true">
          <h2>Are you already registered?</h2>
          <p>Sign in to fetch details.</p>

          <form @submit.prevent="handleLogin">
            <input
              v-model="form.emailOrMobile"
              class="login-input"
              placeholder="Email or Mobile"
            />
            <input
              v-model="form.password"
              type="password"
              class="login-input"
              placeholder="Password"
            />
            <button type="submit" class="btn-submit">Submit</button>
          </form>

          <div class="or-divider">OR</div>

          <button class="btn-google" @click="handleGoogleLogin">
            Sign in with Google
          </button>
          <button
            class="btn-close"
            aria-label="Close"
            @click="showLogin = false"
          >
            Close
          </button>
        </div>
      </div>
    </transition>
  </nav>
</template>

<script setup>
import { ref, onMounted } from "vue";
import axios from "axios";
const dropdownOpen = ref(false);
const showLogin = ref(false);
const isLoggedIn = ref(false);
const userName = ref("");
const userInitial = ref("");

const form = ref({ emailOrMobile: "", password: "" });

function handleLogin() {
  console.log("submit", form.value);
  userName.value = form.value.emailOrMobile || "User";
  userInitial.value = userName.value.charAt(0).toUpperCase();
  isLoggedIn.value = true;
  showLogin.value = false;
}

function handleGoogleLogin() {
  window.location.href = "http://localhost:8080/oauth2/authorization/google";
}
function toggleDropdown() {
  dropdownOpen.value = !dropdownOpen.value;
}
function handleLogout() {
  axios.get("http://localhost:8080/logout", { withCredentials: true })
    .then(() => {
      isLoggedIn.value = false;
      userName.value = "";
      userInitial.value = "";
      dropdownOpen.value = false;
      showLogin.value = false;
    })
    .catch(err => console.error("Logout error", err));
}
// // Check if user is already logged in on mount
// onMounted(async () => {
//   try {
//     const res = await axios.get("http://localhost:8080/user", {
//       withCredentials: true
//     });
//     if (res.data?.name) {
//       userName.value = res.data.name;
//       userInitial.value = userName.value.charAt(0).toUpperCase();
//       isLoggedIn.value = true;
//     }
//   } catch (error) {
//     console.log("User not logged in", error);
//   }
// });
onMounted(async () => {
  try {
    const res = await axios.get("http://localhost:8080/user", {
      withCredentials: true
    });
    if (res.data?.name) {
      userName.value = res.data.name;
      userInitial.value = userName.value.charAt(0).toUpperCase();
      isLoggedIn.value = true;
    }
  } catch (error) {
    console.log("User not logged in", error);
  }
});
</script>

<style scoped>
/* keep your existing styles exactly */
.navbar {
  position: fixed;
  top: 0;
  width: 100%;
  background: #8b5e3c;
  z-index: 60;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}
.navbar-container {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 1rem;
  height: 72px;
  box-sizing: border-box;
}
.navbar-logo {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}
.navbar-logo-img {
  height: 40px;
  width: auto;
  display: block;
}
.navbar-logo-text {
  font-family: "Inter", sans-serif; 
  color: #a3c76d;
  font-size: 1.1rem;
  font-weight: 700;
}
.navbar-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.navbar-links {
  display: none;
  gap: 1.25rem;
  align-items: center;
}
.desktop-only {
  display: none;
}
@media (min-width: 768px) {
  .desktop-only {
    display: flex;
  }
  .navbar-links {
    display: flex;
  }
}
.navbar-link {
  color: #ffffff !important;
  text-decoration: none;
  font-family: "Inter", sans-serif;
  font-weight: 500;
  font-size: 0.98rem;
  position: relative;
  padding: 0.125rem 0;
}
.navbar-link::after {
  content: "";
  position: absolute;
  width: 0%;
  height: 2px;
  left: 0;
  bottom: -6px;
  background-color: #fff;
  transition: width 0.25s ease;
}
.navbar-link:hover::after {
  width: 100%;
}
.navbar-actions {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}
.btn-donate {
  background: #a3c76d;
  color: #fff;
  padding: 0.45rem 0.9rem;
  border-radius: 8px;
  font-weight: 600;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
}
.btn-donate:hover {
  background: #8f9f4a;
}
.btn-login {
  background: transparent;
  color: #fff;
  border: 1px solid rgba(255, 255, 255, 0.12);
  padding: 0.45rem 0.9rem;
  border-radius: 8px;
  font-weight: 600;
}
.btn-login:hover {
  background: rgba(255, 255, 255, 0.06);
}
@media (max-width: 767px) {
  .navbar-container {
    height: 64px;
  }
}
.login-modal {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 200;
}
.login-box {
  background: #fff;
  padding: 1.5rem;
  border-radius: 10px;
  width: 92%;
  max-width: 420px;
  box-sizing: border-box;
}
.login-box h2 {
  margin: 0 0 0.5rem;
  font-size: 1.1rem;
}
.login-box p {
  margin: 0 0 1rem;
  color: #444;
}
.login-input {
  width: 100%;
  padding: 0.6rem;
  margin-bottom: 0.75rem;
  border-radius: 6px;
  border: 1px solid #ddd;
}
.btn-submit {
  width: 100%;
  padding: 0.6rem;
  background: #8b5e3c;
  color: #fff;
  border-radius: 8px;
  border: none;
  font-weight: 600;
  margin-bottom: 0.75rem;
}
.btn-google {
  width: 100%;
  padding: 0.6rem;
  background: #db4437;
  color: #fff;
  border-radius: 8px;
  border: none;
  font-weight: 600;
}
.btn-close {
  margin-top: 0.5rem;
  background: transparent;
  border: none;
  color: #666;
}
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
.user-dropdown {
  position: relative;
  display: inline-block;
}

/* .dropdown-menu {
  position: absolute;
  right: 0;
  margin-top: 0.5rem;
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 6px;
  min-width: 120px;
  z-index: 100;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
} */

/* .dropdown-item {
  display: block;
  width: 100%;
  padding: 0.5rem 0.75rem;
  text-align: left;
  background: none;
  border: none;
  cursor: pointer;
  font-size: 0.9rem;
  color: #333;
}

.dropdown-item:hover {
  background: #f3f3f3;
} */

 .dropdown-menu {
  position: absolute;
  right: 0;
  margin-top: 0.5rem;
  background: transparent; /* dropdown itself is invisible, only button shows */
  border: none;
  padding: 0;
  z-index: 1000;
}


.dropdown-menu .btn-login {
  width: 100%;
  background: #8b5e3c;  /* solid brown background */
  color: #fff;
  border: none;
  text-align: left;
  font-size: 0.95rem;
  padding: 0.5rem 1rem;
}

.dropdown-menu .btn-login:hover {
  background: #70492e; /* darker brown on hover */
}
.btn-logout {
  width: 100%;
  background: #8b5e3c;   /* solid brown */
  color: #fff;
  border: none;           /* no border */
  border-radius: 8px;     /* ✅ rounded corners */
  text-align: left;
  font-size: 0.95rem;
  padding: 0.5rem 1rem;
  font-weight: 600;
  cursor: pointer;
}

.btn-logout:hover {
  background: #70492e;    /* darker brown on hover */
}
</style>
