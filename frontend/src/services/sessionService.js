class SessionService {
  constructor() {
    this.checkInterval = null;
  }

  // เริ่มการตรวจสอบ session
  startSessionCheck() {
    // ล้าง interval เดิมถ้ามี
    if (this.checkInterval) {
      clearInterval(this.checkInterval);
    }

    // ตั้งค่า interval ใหม่ (ตรวจสอบทุก 1 นาที)
    this.checkInterval = setInterval(() => {
      this.checkTokenExpiry();
    }, 60000);
  }

  // ตรวจสอบการหมดอายุของ token
  checkTokenExpiry() {
    const expiresAt = localStorage.getItem("expiresAt");
    
    if (!expiresAt) return;
    
    const timeUntilExpiry = parseInt(expiresAt) - Date.now();
    
    // เตือน 5 นาทีก่อนหมดอายุ
    if (timeUntilExpiry > 0 && timeUntilExpiry < 5 * 60 * 1000) {
      this.showExpiryWarning(timeUntilExpiry);
    }
    
    // หมดอายุแล้ว
    if (timeUntilExpiry <= 0) {
      this.handleTokenExpiry();
    }
  }

  // แสดงการเตือน
  showExpiryWarning(timeUntilExpiry) {
    const minutes = Math.ceil(timeUntilExpiry / 60000);
    const warningMessage = `Session ของคุณจะหมดอายุใน ${minutes} นาที กรุณาบันทึกงานของคุณ`;
    
    // ใช้ UI framework notification ตามความเหมาะสม
    if (typeof window !== 'undefined' && window.alert) {
      alert(warningMessage);
    }
    
    console.warn(warningMessage);
  }

  // จัดการเมื่อ token หมดอายุ
  handleTokenExpiry() {
    localStorage.removeItem("access_token");
    localStorage.removeItem("expiresAt");
    localStorage.removeItem("user_data");
    
    if (typeof window !== 'undefined' && window.alert) {
      alert("Session หมดอายุแล้ว กรุณาเข้าสู่ระบบอีกครั้ง");
    }
    
    // Redirect ไปหน้า login
    if (typeof window !== 'undefined' && window.location) {
      window.location.href = "/login";
    }
  }

  // ออกจากระบบ
  logout() {
    localStorage.removeItem("access_token");
    localStorage.removeItem("expiresAt");
    localStorage.removeItem("user_data");
    
    if (this.checkInterval) {
      clearInterval(this.checkInterval);
      this.checkInterval = null;
    }
    
    // Redirect ไปหน้า login
    if (typeof window !== 'undefined' && window.location) {
      window.location.href = "/login";
    }
  }

  // ตรวจสอบว่ามี session ที่ active อยู่หรือไม่
  isSessionActive() {
    const token = localStorage.getItem("access_token");
    const expiresAt = localStorage.getItem("expiresAt");
    
    return token && expiresAt && Date.now() < parseInt(expiresAt);
  }

  // ขยายอายุ session
  extendSession(additionalTime = 2 * 60 * 60 * 1000) {
    const currentExpiresAt = localStorage.getItem("expiresAt");
    let newExpiresAt;
    
    if (currentExpiresAt) {
      newExpiresAt = parseInt(currentExpiresAt) + additionalTime;
    } else {
      newExpiresAt = Date.now() + additionalTime;
    }
    
    localStorage.setItem("expiresAt", newExpiresAt.toString());
    return newExpiresAt;
  }
}

// สร้าง instance เดียวสำหรับทั้งแอป
export const sessionService = new SessionService();