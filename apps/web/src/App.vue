<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const API = import.meta.env.VITE_API_URL
const counter = ref(null)
const loading = ref(true)
const error = ref('')

async function load() {
  try {
    const { data } = await axios.get(`${API}/counter`)
    counter.value = data
  } catch (e) {
    error.value = 'Failed to load counter'
  } finally {
    loading.value = false
  }
}

async function action(kind) {
  if (!counter.value) return
  const { data } = await axios.post(`${API}/counters/${counter.value.id}/${kind}`)
  counter.value = data
}

// subtle “pop” on change
const pop = ref(false)
async function act(kind) {
  await action(kind)
  pop.value = false
  requestAnimationFrame(() => { pop.value = true })
}

onMounted(load)
</script>

<template>
  <div class="min-h-screen flex items-center justify-center p-4 bg-[linear-gradient(120deg,#0f172a,#0b1220_50%,#0f172a)]">
    <div class="w-full max-w-md rounded-[var(--radius-card)] backdrop-blur-xl bg-white/10 ring-1 ring-white/15 shadow-[var(--shadow-card)] p-6 md:p-8">
      <div class="text-center mb-6">
        <div class="text-xs sm:text-sm uppercase tracking-[0.2em] text-white/70">Counter</div>

        <div class="mt-2">
          <span
            v-if="!loading && counter"
            :class="[
              'block font-extrabold text-white drop-shadow-sm leading-none select-none',
              'text-7xl sm:text-8xl md:text-9xl',
              pop ? 'scale-105 transition-transform duration-150 ease-out' : 'transition-none'
            ]"
            aria-live="polite"
            :aria-label="`Current value ${counter.value}`"
          >
            {{ counter.value }}
          </span>
          <span v-else class="text-white/70 text-lg">Loading…</span>
        </div>

        <p v-if="error" class="mt-2 text-rose-300 text-xs">{{ error }}</p>
      </div>

      <div class="grid grid-cols-3 gap-3">
        <!-- Decrement -->
        <button
          @click="act('decrement')"
          class="h-14 rounded-2xl bg-white/10 hover:bg-white/15 active:scale-[0.98] ring-1 ring-white/20 backdrop-blur-md transition
                 focus:outline-none focus-visible:ring-[var(--ring-strong)] text-white text-xl font-semibold"
          aria-label="Decrease by one"
        >–</button>

        <!-- Reset (primary gradient) -->
        <button
          @click="act('reset')"
          class="h-14 rounded-2xl text-white font-bold ring-1 ring-white/20 shadow-xl transition
                 bg-[linear-gradient(90deg,#6366f1,#d946ef)]
                 hover:saturate-150 active:scale-[0.98]
                 focus:outline-none focus-visible:ring-[var(--ring-strong)]"
          aria-label="Reset to zero"
        >Reset</button>

        <!-- Increment -->
        <button
          @click="act('increment')"
          class="h-14 rounded-2xl bg-white/10 hover:bg-white/15 active:scale-[0.98] ring-1 ring-white/20 backdrop-blur-md transition
                 focus:outline-none focus-visible:ring-[var(--ring-strong)] text-white text-xl font-semibold"
          aria-label="Increase by one"
        >+</button>
      </div>
    </div>
  </div>
</template>

<style>
@media (prefers-reduced-motion: reduce) {
  * { transition: none !important; animation: none !important; }
}
</style>
