<template>
  <v-main>
    <v-container>
      <!-- ปุ่มควบคุม -->
      <v-row class="align-center">
        <v-col cols="auto">
          <v-btn color="red" @click="goBack" class="btn-back">
            <v-icon start>mdi-arrow-left</v-icon> กลับ
          </v-btn>
        </v-col>
        <v-col cols="auto">
          <v-btn color="green-darken-4" @click="addParent">
            <v-icon start>mdi-account-cowboy-hat-outline</v-icon>
            เพิ่มข้อมูลผู้ปกครอง
          </v-btn>
        </v-col>
      </v-row>

      <div style="height: 24px"></div>

      <!-- ตารางข้อมูลผู้ปกครอง -->
      <v-sheet rounded class="pa-4" style="background-color: #f5f7fa">
        <v-data-table :headers="parentHeaders" :items="filteredParents" :items-per-page="10" :search="search"
          class="custom-table custom-footer">

          <template v-slot:top>
            <v-toolbar flat class="bg-green-darken-4 text-white">
              <v-toolbar-title>
                <v-icon icon="mdi-account-cowboy-hat-outline" size="x-small" class="me-2" color="white" />
                ตารางข้อมูลผู้ปกครอง
              </v-toolbar-title>
              <v-spacer />
              <v-text-field v-model="parentSearch" label="ค้นหา" variant="outlined" density="compact" clearable
                hide-details style="max-width: 250px" />
            </v-toolbar>
          </template>

          <template v-slot:header="{ headers }">
            <thead>
              <tr>
                <th v-for="header in headers" :key="header.key" style="background-color: #2e7d32; color: white">
                  {{ header.title }}
                </th>
              </tr>
            </thead>
          </template>

          <template v-slot:item="{ item, index }">
            <tr :style="{
              backgroundColor: index % 2 === 0 ? '#E8F5E9' : '#FFFFFF',
            }">
              <td style="color: black">{{ index + 1 }}</td>
              <td style="color: black">{{ item.full_name }}</td>
              <td style="color: black">{{ item.phone_number }}</td>
              <td style="color: black">{{ item.email }}</td>
              <td style="color: black">{{ item.relation }}</td>
              <td style="color: black">{{ item.student_name }}</td>
              <td class="text-center">
                <v-avatar color="yellow-darken-2" size="32" class="elevation-1" style="cursor: pointer"
                  @click="editItem(item)">
                  <v-icon color="white" icon="mdi-pencil" size="20" />
                </v-avatar>
              </td>
              <td class="text-center">
                <v-avatar color="red-darken-1" size="32" class="elevation-1" style="cursor: pointer"
                  @click="confirmDelete(item)">
                  <v-icon color="white" icon="mdi-delete" size="20" />
                </v-avatar>
              </td>
            </tr>
          </template>
        </v-data-table>
      </v-sheet>

      <!-- Dialog เพิ่ม/แก้ไขข้อมูล -->
      <v-dialog v-model="dialog" max-width="850" persistent>
        <v-card style="background-color: #ffffff; color: black">
          <v-toolbar flat :color="isEditing ? 'warning' : 'success'">
            <v-card-title class="text-white">
              <v-icon start class="mr-2">
                {{ isEditing ? "mdi-pencil" : "mdi-plus" }}
              </v-icon>
              {{ isEditing ? "แก้ไขข้อมูลผู้ปกครอง" : "เพิ่มข้อมูลผู้ปกครอง" }}
            </v-card-title>
          </v-toolbar>
          <v-card-text>
            <v-row>
              <!-- เลขบัตรประชาชน -->
              <v-col cols="12" sm="6">
                <v-text-field v-model="form.id_card_number" label="เลขบัตรประชาชน" variant="outlined" color="success"
                  :rules="[required]" />
              </v-col>
              <!-- คำนำหน้า -->
              <v-col cols="12" sm="6">
                <v-select v-model="form.prefix_name" :items="['นาย', 'นาง', 'นางสาว']" label="คำนำหน้า"
                  variant="outlined" color="success" :rules="[required]" />
              </v-col>
              <!-- ชื่อ -->
              <v-col cols="12" sm="6">
                <v-text-field v-model="form.first_name" label="ชื่อ" variant="outlined" color="success"
                  :rules="[required]" />
              </v-col>

              <!-- นามสกุล -->
              <v-col cols="12" sm="6">
                <v-text-field v-model="form.last_name" label="นามสกุล" variant="outlined" color="success"
                  :rules="[required]" />
              </v-col>

              <!-- ความสัมพันธ์ -->
              <v-col cols="12" sm="6">
                <v-select v-model="form.relation" :items="['บิดา', 'มารดา', 'ผู้ปกครอง']" label="ความสัมพันธ์"
                  variant="outlined" color="success" :rules="[required]" />
              </v-col>

              <!-- นักเรียนที่ดูแล -->
              <v-col cols="12" sm="6">
                <!-- ช่องค้นหา -->
                <v-text-field v-model="studentSearch" label="ค้นหานักเรียน" variant="outlined" density="compact"
                  clearable prepend-inner-icon="mdi-magnify" color="success" />

                <!-- รายชื่อนักเรียน -->
                <v-select v-model="form.student_id" :items="filteredStudents" item-title="student_name"
                  item-value="student_id" label="นักเรียน" variant="outlined" color="success" multiple chips clearable
                  :rules="[
                    (v) => (!!v && v.length > 0) || 'กรุณาเลือกอย่างน้อย 1 คน',
                  ]" />

                <!-- <v-select v-model="form.student_id" :items="student" item-title="student_name" item-value="student_id"
                  label="นักเรียน" variant="outlined" color="success" multiple chips clearable :rules="[
                    (v) => (!!v && v.length > 0) || 'กรุณาเลือกอย่างน้อย 1 คน',
                  ]" /> -->
              </v-col>

              <!-- อีเมล -->
              <v-col cols="12" sm="6">
                <v-text-field v-model="form.email" label="อีเมล" variant="outlined" color="success" type="email" />
              </v-col>

              <!-- เบอร์โทร -->
              <v-col cols="12" sm="6">
                <v-text-field v-model="form.phone_number" label="เบอร์โทรศัพท์" variant="outlined" color="success"
                  type="tel" />
              </v-col>

              <!-- อาชีพ -->
              <v-col cols="12" sm="6">
                <v-text-field v-model="form.occupation" label="อาชีพ" variant="outlined" color="success" />
              </v-col>
            </v-row>
          </v-card-text>
          <v-card-actions class="justify-end">
            <v-btn color="red-darken-1" variant="flat" class="text-white" @click="dialog = false">
              ยกเลิก
            </v-btn>
            <v-btn color="green-darken-1" variant="flat" class="text-white ml-2" @click="save" :disabled="!isFormValid"
              :loading="loading">
              บันทึก
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>

      <!-- Dialog ยืนยันการลบ -->
      <v-dialog v-model="confirmDeleteDialog" max-width="400">
        <v-card>
          <v-card-title class="text-h6">ยืนยันการลบ</v-card-title>
          <v-card-text>คุณต้องการลบข้อมูลใช่หรือไม่?</v-card-text>
          <v-card-actions>
            <v-spacer />
            <v-btn color="red-darken-1" variant="flat" class="text-white"
              @click="confirmDeleteDialog = false">ยกเลิก</v-btn>
            <v-btn color="green-darken-1" variant="flat" class="text-white" @click="deleteItem">ลบ</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>

      <!-- Snackbar -->
      <v-snackbar v-model="snackbar.show" :color="snackbar.color" :timeout="2000" location="center"
        transition="slide-y-transition">
        <v-icon icon="mdi-alert-circle-outline" class="mr-2" size="large" color="white" />
        {{ snackbar.text }}
      </v-snackbar>
    </v-container>
  </v-main>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useRouter } from "vue-router";
import axios from "@/utils/axios";
import { API_BASE_URL } from "@/assets/config";

const router = useRouter();

// ตัวแปร UI
const dialog = ref(false);
const confirmDeleteDialog = ref(false);
const loading = ref(false);
const isEditing = ref(false);

// ค้นหา
const parentSearch = ref("");
const parents = ref([]); // ดึงมาจาก backend


// ข้อมูลนักเรียน
const studentSearch = ref("");
const students = ref([]) // ดึงจาก API

// ✅ ตัวกรองผลลัพธ์
const filteredParents = computed(() => {
  if (!parentSearch.value) return parents.value;
  const keyword = parentSearch.value.toLowerCase();
  return parents.value.filter((p) =>
    Object.values(p).some(
      (val) => String(val).toLowerCase().includes(keyword)
    )
  );
});

// ฟอร์ม
const defaultForm = () => ({
  parent_id: null,
  id_card_number: "",
  prefix_name: "",
  first_name: "",
  last_name: "",
  email: "",
  phone_number: "",
  relation: "",
  occupation: "",
  student_id: [], // เก็บ student_id ที่เลือก
});
const form = ref(defaultForm());

// reset ฟอร์ม
const resetForm = () => {
  form.value = defaultForm();
  loading.value = false;
  isEditing.value = false;
};

// 👀 watcher: reset ทุกครั้งที่ปิด dialog
watch(dialog, (val) => {
  if (!val) resetForm();
});

// Headers
const parentHeaders = [
  { title: "ลำดับ", key: "num", sortable: false },
  { title: "ชื่อ-สกุล", key: "full_name" },
  { title: "โทรศัพท์", key: "phone_number" },
  { title: "อีเมล", key: "email" },
  { title: "ความสัมพันธ์", key: "relation" },
  { title: "นักเรียนที่ดูแล", key: "student_name" },
  { title: "แก้ไข", key: "edit", sortable: false, align: "center" },
  { title: "ลบ", key: "delete", sortable: false, align: "center" },
];

// Validation
const required = (v) => !!v || "กรุณากรอกข้อมูล";
const isFormValid = computed(() => {
  return (
    form.value.id_card_number &&
    form.value.prefix_name &&
    form.value.first_name &&
    form.value.last_name &&
    form.value.phone_number &&
    form.value.email &&
    form.value.relation &&
    form.value.student_id
  );
});

// Go back
const goBack = () => router.push("/home");

// กรองนักเรียนตามช่องค้นหา
const filteredStudents = computed(() => {
  if (!studentSearch.value) return students.value
  return students.value.filter((s) =>
    s.student_name.toLowerCase().includes(studentSearch.value.toLowerCase())
  )
})

// Snackbar
const snackbar = ref({ show: false, text: "", color: "success" });

// Snackbar function
const showSnackbar = (text, color = "success") => {
  snackbar.value = { show: true, text, color };
};

// เพิ่ม
const addParent = () => {
  resetForm();
  isEditing.value = false;
  dialog.value = true;
};

// แก้ไข
// const editItem = (item) => {
//   resetForm(); // ✅ ป้องกันข้อมูลซ้อน
//   isEditing.value = true;
//   form.value = { ...item };
//   dialog.value = true;
// };
const editItem = (item) => {
  resetForm();
  isEditing.value = true;

  // แปลง student_id จาก string → array (ถ้ามีหลายคน เช่น "1,2,3")
  const studentIds = Array.isArray(item.student_id)
    ? item.student_id
    : item.student_id
      ? item.student_id.toString().split(",").map((id) => Number(id.trim()))
      : [];

  form.value = {
    parents_id: item.parents_id || item.parent_id, // รองรับทั้งสองกรณี
    id_card_number: item.id_card_number,
    prefix_name: item.prefix_name,
    first_name: item.first_name,
    last_name: item.last_name,
    email: item.email,
    phone_number: item.phone_number,
    relation: item.relation,
    occupation: item.occupation,
    student_id: studentIds, // ✅ เซ็ตเป็น array
  };

  dialog.value = true;
};



// Confirm delete ลบ
const itemToDelete = ref(null);
const confirmDelete = (item) => {
  itemToDelete.value = item.parents_id;
  confirmDeleteDialog.value = true;
};

const deleteItem = async () => {
  try {
    loading.value = true;
    const token = localStorage.getItem("access_token");
    await axios.delete(`${API_BASE_URL}/parents/delete/${itemToDelete.value}`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    showSnackbar("ลบข้อมูลสำเร็จ");
    confirmDeleteDialog.value = false;
    await fetchParents();
  } catch (err) {
    console.error(err);
    showSnackbar("เกิดข้อผิดพลาดในการลบข้อมูล", "error");
  } finally {
    loading.value = false;
  }
};

// บันทึก แก้ไข หรือ เพิ่ม
const save = async () => {
  try {
    loading.value = true;
    const token = localStorage.getItem("access_token");
    // Payload
    const payload = { ...form.value };
    // console.log("เลือกผู้ปกครอง:", form.value);
    // console.log("📡 URL:", `${API_BASE_URL}/parents/update/${payload.parents_id}`);

    if (isEditing.value) {
      await axios.put(
        `${API_BASE_URL}/parents/update/${payload.parents_id}`,
        payload,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      showSnackbar("อัปเดตข้อมูลสำเร็จ");
    } else {
      await axios.post(`${API_BASE_URL}/parents/insert`, payload, {
        headers: { Authorization: `Bearer ${token}` },
      });
      showSnackbar("เพิ่มข้อมูลสำเร็จ");
    }
    dialog.value = false;
    await fetchParents();
  } catch (err) {
    console.error(err);
    showSnackbar("เกิดข้อผิดพลาดในการบันทึก", "error");
  } finally {
    loading.value = false;
  }
};

// โหลดผู้ปกครอง
const fetchParents = async () => {
  try {
    const token = localStorage.getItem("access_token");
    const res = await axios.get(`${API_BASE_URL}/parents_all`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    // parents.value = res.data.parents || [];
    const data = res.data.parents || [];
    // console.log("ข้อมูลที่ได้จาก backend:", data);

    parents.value = data.map((t) => ({
      ...t,
      full_name: `${t.prefix_name || ""}${t.first_name || ""} ${t.last_name || ""
        }`,
    }));
  } catch (err) {
    console.error(err);
    showSnackbar("โหลดข้อมูลผู้ปกครองไม่สำเร็จ", "error");
  }
};

// ดึงข้อมูลนักเรียน
const fetchStudents = async () => {
  try {
    const token = localStorage.getItem("access_token");
    const res = await axios.get(`${API_BASE_URL}/students_all`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    students.value = res.data.students.map((s) => ({
      student_id: s.student_id,
      student_name: `${s.prefix_name}${s.first_name} ${s.last_name} (${s.nickname || "-"
        })`,
    }));

  } catch (err) {
    console.error("โหลดรายชื่อนักเรียนล้มเหลว", err);
  }
};

// โหลดข้อมูลเริ่มต้น
onMounted(() => {
  fetchParents();
  fetchStudents();
});
</script>
