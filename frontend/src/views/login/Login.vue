<template>
  <v-main class="vector-bg center-content">
    <div class="login-container">
      <div class="logo">
        <img src="@/assets/image/logo.png" alt="Company logo" width="180" height="180" />
      </div>

      <h2 class="login-title">เข้าสู่ระบบ</h2>
      <form @submit.prevent="handleLogin">
        <div class="form-group">
          <input type="text" id="username" v-model="username" required placeholder="Username" class="vector-input" />
        </div>
        <div class="form-group">
          <input type="password" id="password" v-model="password" required placeholder="Password"
            class="vector-input" />
        </div>
        <button type="submit" :disabled="loading" class="vector-button">
          {{ loading ? "Processing..." : "LOGIN" }}
        </button>
      </form>

      <p class="forgot-password">Forgot Password?</p>
      <p v-if="message" class="message">{{ message }}</p>
      <p>-------------</p>
      <div class="text-caption message" style="
          position: absolute;
          left: 50%;
          transform: translateX(-50%);
          bottom: 16px;
          color: blue;
        ">
        &copy; 2025-{{ new Date().getFullYear() }}
        <span class="d-none d-sm-inline-block">Smartkids+Digital Life</span>
        <a class="text-decoration-none" href="https://www.google.com/" rel="noopener noreferrer" target="_blank"
          style="color: blue">
        </a>
      </div>
    </div>
  </v-main>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";
import { API_BASE_URL } from "@/assets/config";

const username = ref("");
const password = ref("");
const message = ref("");
const loading = ref(false);

const router = useRouter();

// ตรวจสอบว่ามี token อยู่แล้วหรือไม่
onMounted(() => {
  const token = localStorage.getItem("access_token");
  const expiresAt = localStorage.getItem("expiresAt");

  if (token && expiresAt && Date.now() < parseInt(expiresAt)) {
    // ถ้ามี token ที่ยังไม่หมดอายุ ให้ redirect ไปหน้า home
    router.push("/home");
  } else {
    // ถ้า token หมดอายุหรือไม่มี ให้ล้างข้อมูล
    localStorage.removeItem("access_token");
    localStorage.removeItem("expiresAt");
    localStorage.removeItem("user_data");
  }
});

const handleLogin = async () => {
  loading.value = true;
  message.value = "";

  try {
    const res = await axios.post(`${API_BASE_URL}/login`, {
      username: username.value,
      password: password.value,
    });

    if (res.data.access_token) {
      const token = res.data.access_token;

      // ใช้ค่า expires_in จาก server หรือใช้ค่า default 7 วัน
      const expiresIn = res.data.expires_in || 7 * 24 * 60 * 60 * 1000;
      const expiresAt = Date.now() + expiresIn;

      localStorage.setItem("access_token", token);
      localStorage.setItem("expiresAt", expiresAt.toString());

      // console.log("access_token:", token);
      // console.log("Login successful, expires In:", new Date(expiresIn));
      // console.log("Login successful, expires At:", new Date(expiresAt));

      message.value = "เข้าสู่ระบบสำเร็จ";

      const user = await getCurrentUser();
      if (user) {
        localStorage.setItem("user_data", JSON.stringify(user));

        // เริ่มการตรวจสอบการหมดอายุของ token
        startTokenExpiryCheck();

        await router.push("/home");
      } else {
        message.value = "ไม่สามารถโหลดข้อมูลผู้ใช้";
      }
    } else {
      message.value = "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง";
    }
  } catch (err) {
    console.log("❌ Login failed:", err.response?.data || err.message);
    if (err.response && err.response.data?.message) {
      message.value = err.response.data.message;
    } else {
      message.value = "เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์";
    }
  } finally {
    loading.value = false;
  }
};

// ฟังก์ชันตรวจสอบการหมดอายุของ token
const startTokenExpiryCheck = () => {
  // ตรวจสอบทุก 1 นาที
  setInterval(() => {
    const expiresAt = localStorage.getItem("expiresAt");

    if (!expiresAt) return;

    const timeUntilExpiry = parseInt(expiresAt) - Date.now();

    // เตือน 5 นาทีก่อนหมดอายุ
    if (timeUntilExpiry > 0 && timeUntilExpiry < 5 * 60 * 1000) {
      showExpiryWarning(timeUntilExpiry);
    }

    // หมดอายุแล้ว
    if (timeUntilExpiry <= 0) {
      handleTokenExpiry();
    }
  }, 60000); // ตรวจสอบทุก 1 นาที
};

// แสดงการเตือนก่อน token หมดอายุ
const showExpiryWarning = (timeUntilExpiry) => {
  const minutes = Math.ceil(timeUntilExpiry / 60000);
  const warningMessage = `Session ของคุณจะหมดอายุใน ${minutes} นาที กรุณาบันทึกงานของคุณ`;

  // ใช้ alert หรือ UI framework notification ตามความเหมาะสม
  alert(warningMessage);
  console.warn(warningMessage);
};

// จัดการเมื่อ token หมดอายุ
const handleTokenExpiry = () => {
  localStorage.removeItem("access_token");
  localStorage.removeItem("expiresAt");
  localStorage.removeItem("user_data");

  alert("Session หมดอายุแล้ว กรุณาเข้าสู่ระบบอีกครั้ง");
  router.push("/login");
};

// ดึงข้อมูลผู้ใช้ที่ Login
async function getCurrentUser() {
  try {
    const token = localStorage.getItem("access_token");
    if (!token) throw new Error("Token not found");

    const response = await axios.get(`${API_BASE_URL}/user/me`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    const user = response.data;
    localStorage.setItem("user", JSON.stringify(user));

    return user;
  } catch (error) {
    const msg =
      error.response?.data?.message || error.message || "Unknown error";
    console.error("⛔ ดึงข้อมูลผู้ใช้ล้มเหลว:", msg);

    if (error.response?.status === 401) {
      localStorage.removeItem("access_token");
      localStorage.removeItem("expiresAt");
      router.push("/login");
    }

    return null;
  }
}
</script>

<style scoped>
/* สไตล์เดิมไม่เปลี่ยนแปลง */
.center-content {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  padding: 0;
  margin: 0;
  box-sizing: border-box;
}

.login-container {
  width: 100%;
  max-width: 420px;
  padding: 24px;
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.vector-input {
  width: 100%;
  padding: 12px 16px;
  margin: 8px 0;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-size: 14px;
  box-sizing: border-box;
}

.vector-button {
  width: 100%;
  padding: 12px 16px;
  margin-top: 12px;
  background: #1976d2;
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.2s ease;
}

.vector-button:hover {
  background: #1565c0;
}

.login-title {
  margin: 16px 0;
  font-size: 20px;
  font-weight: 600;
}

.forgot-password {
  margin-top: 16px;
  font-size: 14px;
  color: #1976d2;
  cursor: pointer;
}

.message {
  margin-top: 12px;
  font-size: 14px;
  color: red;
}
</style>
