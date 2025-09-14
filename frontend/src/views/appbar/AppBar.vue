<template>
  <v-app-bar app color="#3498db" dark>
    <!-- ปุ่ม toggle drawer -->
    <template #prepend>
      <v-app-bar-nav-icon @click="$emit('toggle-drawer')" />
      <v-avatar size="40">
        <v-img src="@/assets/image/logo.png" alt="Logo" />
      </v-avatar>
    </template>

    <!-- ชื่อแอป -->
    <v-toolbar-title>Smartkids+Digital Life</v-toolbar-title>

    <v-spacer></v-spacer>

    <!-- แสดงข้อมูลผู้ใช้และปุ่ม Logout -->
    <div class="user-info">
      <span class="mr-2">สวัสดี, {{ userName }}</span>
      <v-btn icon @click="confirmLogout" title="ออกจากระบบ">
        <v-icon>mdi-logout</v-icon>
      </v-btn>
    </div>
  </v-app-bar>

  <!-- Dialog ยืนยันการออกจากระบบ -->
  <v-dialog v-model="logoutDialog" max-width="400">
    <v-card class="confirm-delete-dialog">
      <v-card-title class="text-h6 confirm-delete-title"
        >ยืนยันการออกจากระบบ</v-card-title
      >
      <v-card-text class="confirm-delete-text"
        >คุณต้องการออกจากระบบจริงหรือไม่?</v-card-text
      >
      <v-card-actions class="confirm-delete-actions">
        <v-spacer />
        <!-- ปุ่มยกเลิก -->
        <v-btn
          color="red-darken-1"
          variant="flat"
          class="text-white"
          @click="logoutDialog = false"
          >ยกเลิก</v-btn
        >
        <!-- ปุ่มยืนยันลบ -->
        <v-btn
          color="green-darken-1"
          variant="flat"
          class="text-white"
          @click="logout"
          >ออกจากระบบ</v-btn
        >
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRouter } from "vue-router";
import { sessionService } from "@/services/sessionService";

const router = useRouter();
const logoutDialog = ref(false);

// รับ user data จาก localStorage
const userData = computed(() => {
  try {
    const user =
      localStorage.getItem("user_data") || localStorage.getItem("user");
    return user ? JSON.parse(user) : null;
  } catch {
    return null;
  }
});

// ดึงชื่อผู้ใช้
const userName = computed(() => {
  if (!userData.value) return "ผู้ใช้";

  // ตรวจสอบรูปแบบข้อมูลผู้ใช้
  if (userData.value.first_name && userData.value.last_name) {
    return `${userData.value.first_name} ${userData.value.last_name}`;
  } else if (userData.value.name) {
    return userData.value.name;
  } else if (userData.value.username) {
    return userData.value.username;
  }

  return "ผู้ใช้";
});

// เปิด dialog ยืนยันการออกจากระบบ
const confirmLogout = () => {
  logoutDialog.value = true;
};

// ฟังก์ชันออกจากระบบ
const logout = async () => {
  try {
    // เรียกใช้ sessionService สำหรับจัดการการออกจากระบบ
    sessionService.logout();

    // ปิด dialog
    logoutDialog.value = false;

    // Redirect ไปหน้า login
    router.push("/login");
  } catch (error) {
    console.error("Error during logout:", error);
    // หากมี error ให้ล้างข้อมูล locally  anyway
    localStorage.removeItem("access_token");
    localStorage.removeItem("expiresAt");
    localStorage.removeItem("user_data");
    localStorage.removeItem("user");

    router.push("/login");
  }
};

// รับ emit จาก props
const emit = defineEmits(["toggle-drawer"]);

onMounted(() => {
  emit("toggle-drawer");
});
</script>

<style scoped></style>
