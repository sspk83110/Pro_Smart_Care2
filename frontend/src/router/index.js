import { createRouter, createWebHistory } from "vue-router";
import login from "../views/login/Login.vue";
import home from "../views/home/Home.vue";
import home_view from "../views/home/Home_View.vue";
import users from "../views/users/Users.vue";
import users_view from "../views/users/Users_View.vue";
import students from "../views/students/Sudents.vue";
import students_view from "../views/students/Students_View.vue";
import parents from "@/views/parents/Parents.vue";
import parents_view from "@/views/parents/Parents_View.vue";
import years from "../views/years/Years.vue";
import years_view from "../views/years/Years_View.vue";
import classrooms from "../views/classrooms/Classrooms.vue";
import classrooms_view from "../views/classrooms/Classrooms_View.vue";
import teacher from "../views/teacher/Teacher.vue";
import teacher_view from "../views/teacher/Teacher_View.vue";
import health_records from "../views/health_records/HealthRecords.vue";
import health_records_view from "../views/health_records/HealthRecords_View.vue";
import behavior_records from "@/views/behavior_records/BehaviorRecords.vue";
import behavior_records_View from "@/views/behavior_records/BehaviorRecords_View.vue";

// ฟังก์ชันตรวจสอบ access_token
function checkToken() {
  const access_token = localStorage.getItem("access_token");
  const expiresAt = localStorage.getItem("expiresAt");

  if (!access_token || !expiresAt) return false;

  if (Date.now() > Number(expiresAt)) {
    // หมดอายุแล้ว → ลบ access_token
    localStorage.removeItem("access_token");
    localStorage.removeItem("expiresAt");

    return false;
  }

  return true;
}

// กำหนดเส้นทางสำหรับแอปพลิเคชัน
const routes = [
  { path: "/", redirect: "/login" },
  { path: "/login", component: login },
  { path: "/user", component: users },
  {
    path: "/home",
    component: home,
    meta: {
      requiresAuth: true,
    }, // ต้องล็อกอิน
    children: [
      { path: "", component: home_view }, // 👉 /home = Home.vue
    ],
  },
  {
    path: "/users",
    component: users,
    meta: {
      requiresAuth: true,
    }, // ต้องล็อกอิน
    children: [{ path: "", component: users_view }],
  },
  {
    path: "/students",
    component: students,
    meta: {
      requiresAuth: true,
    }, // ต้องล็อกอิน
    children: [{ path: "", component: students_view }],
  },
  {
    path: "/parents",
    component: parents,
    meta: {
      requiresAuth: true,
    }, // ต้องล็อกอิน
    children: [{ path: "", component: parents_view }],
  },
  {
    path: "/years",
    component: years,
    meta: {
      requiresAuth: true,
    }, // ต้องล็อกอิน
    children: [{ path: "", component: years_view }],
  },
  {
    path: "/classrooms",
    component: classrooms,
    meta: {
      requiresAuth: true,
    }, // ต้องล็อกอิน
    children: [{ path: "", component: classrooms_view }],
  },
  {
    path: "/teacher",
    component: teacher,
    meta: {
      requiresAuth: true,
    }, // ต้องล็อกอิน
    children: [{ path: "", component: teacher_view }],
  },
  {
    path: "/health",
    component: health_records,
    meta: {
      requiresAuth: true,
    }, // ต้องล็อกอิน
    children: [{ path: "", component: health_records_view }],
  },
  {
    path: "/behavior",
    component: behavior_records,
    meta: {
      requiresAuth: true,
    }, // ต้องล็อกอิน
    children: [{ path: "", component: behavior_records_View }],
  },
];

// สร้าง router instance
// กำหนด base path เป็น "https://smartkids.banglamung.go.th/" ตามที่ระบุใน vite.config.mjs
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

// 🔒 ตรวจสอบ access_token ก่อนเข้าหน้า
router.beforeEach((to, from, next) => {
  if (to.meta.requiresAuth && !checkToken()) {
    // ถ้า access_token หมดอายุหรือไม่มี → ไปหน้า login
    next("/login");
  } else {
    next();
  }
});

export default router;