<template>
  <v-app>
    <v-main class="white-bg">
      <AppBar @toggle-drawer="drawer = !drawer" />
      <!-- AppBar -->
      <router-view />
      <!-- ตัวนี้จะ render Teacher_View หรือ Add ตาม path -->
      <AppFooter />
      <!-- Footer ด้านล่าง -->
    </v-main>
  </v-app>
</template>

<script setup>
import AppBar from "@/views/appbar/AppBar.vue"; // Appbar แยกออกมา
import AppFooter from "@/views/footer/AppFooter.vue"; // Footer แยกออกมา
</script>

<style scoped></style>
