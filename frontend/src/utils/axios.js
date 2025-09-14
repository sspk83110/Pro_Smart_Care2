import axios from "axios";
import { API_BASE_URL } from "@/assets/config";

const instance = axios.create({
  baseURL: API_BASE_URL,
  withCredentials: true,
  headers: {
    "Content-Type": "application/json",
  },
  timeout: 30000, // ตั้งค่า timeout เป็น 30 วินาที
});

// ฟังก์ชันตรวจสอบการหมดอายุของ token
const isTokenExpired = () => {
  const expiresAt = localStorage.getItem("expiresAt");
  if (!expiresAt) return true;
  
  return Date.now() >= parseInt(expiresAt);
};

// ฟังก์ชันรีเฟรช token
const refreshToken = async () => {
  try {
    const response = await axios.post(`${API_BASE_URL}/auth/refresh`, {}, {
      withCredentials: true
    });
    
    const { token, expires_in } = response.data;
    
    // บันทึก token ใหม่
    localStorage.setItem("access_token", token);
    
    // คำนวณเวลา expiration ใหม่ (หมดอายุใน 7 วัน)
    const expiresAt = Date.now() + (expires_in || 7 * 24 * 60 * 60 * 1000);
    localStorage.setItem("expiresAt", expiresAt.toString());
    
    return token;
  } catch (error) {
    // หากรีเฟรชไม่สำเร็จ ให้ล้างข้อมูลและ redirect ไปหน้า login
    localStorage.removeItem("access_token");
    localStorage.removeItem("expiresAt");
    window.location.href = "/login";
    throw error;
  }
};

// เพิ่ม token อัตโนมัติและจัดการการหมดอายุ
instance.interceptors.request.use(async (config) => {
  const token = localStorage.getItem("access_token");
  
  // ตรวจสอบว่า token หมดอายุหรือไม่
  if (token && isTokenExpired()) {
    // พยายามรีเฟรช token
    try {
      const newToken = await refreshToken();
      config.headers.Authorization = `Bearer ${newToken}`;
    } catch (error) {
      // ไม่สามารถรีเฟรช token ได้
      return Promise.reject(error);
    }
  } else if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  
  return config;
});

// ตรวจจับ token หมดอายุ
instance.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;
    
    // หาก error เป็น 401 และยังไม่เคยพยายามรีทราย
    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;
      
      try {
        // พยายามรีเฟรช token
        const newToken = await refreshToken();
        
        // ดำเนินการ request ใหม่ด้วย token ใหม่
        originalRequest.headers.Authorization = `Bearer ${newToken}`;
        return instance(originalRequest);
      } catch (refreshError) {
        // หากรีเฟรชไม่สำเร็จ ให้ล้างข้อมูลและ redirect
        localStorage.removeItem("access_token");
        localStorage.removeItem("expiresAt");
        window.location.href = "/login";
        return Promise.reject(refreshError);
      }
    }
    
    return Promise.reject(error);
  }
);

export default instance;
