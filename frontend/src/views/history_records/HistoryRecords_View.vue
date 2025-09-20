<template>
  <!-- App Bar ด้านบน -->
  <AppBar @toggle-drawer="drawer = !drawer" />
  <v-main>
    <v-container>
      <!-- ปุ่มควบคุม -->
      <v-row class="align-center">
        <v-col cols="auto" class="pa-0">
          <v-btn color="red" @click="goBack" class="btn-back">
            <v-icon start>mdi-arrow-left</v-icon> กลับ
          </v-btn>
        </v-col>
      </v-row>

      <div style="height: 24px"></div>

      <v-card class="mb-4">
        <v-card-title
          class="d-flex align-center justify-space-between bg-success text-white"
          style="padding-bottom: 20px; height: 65px"
        >
          <span>ข้อมูลย้อนหลัง — {{ title }}</span>
        </v-card-title>

        <v-card-text class="bg-white">
          <!-- ฟิลเตอร์ -->
          <v-form @submit.prevent="onSearch">
            <v-row>
              <!-- DateFrom -->
              <v-col cols="12" md="3">
                <v-menu
                  v-model="showDatePickerFrom"
                  :close-on-content-click="false"
                  transition="scale-transition"
                  offset-y
                  min-width="auto"
                >
                  <template #activator="{ props }">
                    <v-text-field
                      v-bind="props"
                      label="วันที่เริ่มต้น"
                      readonly
                      v-model="displayDateFrom"
                      variant="outlined"
                      prepend-inner-icon="mdi-calendar"
                    />
                  </template>
                  <v-date-picker
                    v-model="selectedDateFrom"
                    color="primary"
                    @update:model-value="updateDisplayFrom"
                  />
                </v-menu>
              </v-col>
              <!-- DateTo -->
              <v-col cols="12" md="3">
                <v-menu
                  v-model="showDatePickerTo"
                  :close-on-content-click="false"
                  transition="scale-transition"
                  offset-y
                  min-width="auto"
                >
                  <template #activator="{ props }">
                    <!-- แสดงผล DD/MM/YYYY พ.ศ. -->
                    <v-text-field
                      v-bind="props"
                      label="วันที่สิ้นสุด"
                      readonly
                      v-model="displayDateTo"
                      variant="outlined"
                      prepend-inner-icon="mdi-calendar"
                    />
                  </template>
                  <v-date-picker
                    v-model="selectedDateTo"
                    color="primary"
                    @update:model-value="updateDisplayTo"
                  />
                </v-menu>
              </v-col>
              <v-col cols="12" md="3">
                <v-text-field
                  v-model="filters.student_code"
                  label="รหัสนักเรียน"
                  variant="outlined"
                />
              </v-col>
              <v-col cols="12" md="3">
                <v-text-field
                  v-model="filters.student_name"
                  label="ชื่อ-สกุลนักเรียน"
                  variant="outlined"
                />
              </v-col>

              <!-- Health Records -->
              <v-col cols="12" md="3" v-if="recordType === 'health'">
                <v-select
                  v-model="filters.attendance_status"
                  :items="statusOptions"
                  item-title="name"
                  item-value="value"
                  label="สถานะการมาเรียน"
                  variant="outlined"
                />
              </v-col>
            </v-row>

            <v-row class="mt-2" justify="end" no-gutters>
              <v-btn color="blue-grey-lighten-4" class="mr-2" @click="onReset"
                >ล้าง</v-btn
              >
              <v-btn color="primary" @click="onSearch">ค้นหา</v-btn>
            </v-row>
          </v-form>
        </v-card-text>
      </v-card>

      <!-- ตาราง Record -->
      <v-sheet rounded>
        <v-data-table
          :headers="headers"
          :items="items"
          :items-per-page="10"
          class="custom-table custom-footer"
        >
          <template v-slot:header="{ headers }">
            <tr>
              <th
                v-for="header in headers"
                :key="header.key"
                style="background-color: #43a047; color: white"
              >
                {{ header.title }}
              </th>
            </tr>
          </template>
          <template v-slot:item="{ item, index }">
            <tr
              :style="{
                backgroundColor: index % 2 === 0 ? '#e8f5e9' : '#ffffff',
              }"
            >
              <td style="color: black">
                {{ formatThaiDate(item.record_date) }}
              </td>
              <td style="color: black">{{ item.student_code }}</td>
              <td style="color: black">{{ item.student_fullname }}</td>
              <td v-if="recordType === 'health'" style="color: black">
                {{ item.attendance_status_name || "-" }}
              </td>
              <td v-else style="color: black">
                {{ item.classroom_name || "-" }}
              </td>
              <td class="text-center">
                <v-avatar
                  color="green darken-2"
                  size="32"
                  class="elevation-1"
                  style="cursor: pointer"
                  @click="viewRecord(item)"
                >
                  <v-icon
                    color="white"
                    icon="mdi-eye-arrow-right-outline"
                    size="20"
                  />
                </v-avatar>
              </td>
            </tr>
          </template>
        </v-data-table>
      </v-sheet>
    </v-container>

    <RecordDialog
      v-model="dialogOpen"
      :type="recordType"
      :record="selectedRecord"
    />
  </v-main>
</template>

<script setup>
import { ref, computed, watch, onMounted } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";
import AppBar from "@/views/appbar/AppBar.vue";
import { API_BASE_URL } from "@/assets/config";
import RecordDialog from "./RecordDialog.vue";

// Router
const router = useRouter();

const props = defineProps({
  type: { type: String, default: "health" }, // รับมาจาก props mapping ใน router
});

const dialogOpen = ref(false);
const selectedRecord = ref(null);

const recordType = ref("health"); // 'health' | 'behavior'
const title = computed(() =>
  recordType.value === "health" ? "บันทึกสุขภาพ" : "บันทึกพฤติกรรม"
);

const headers = computed(() =>
  recordType.value === "health"
    ? [
        { title: "วันที่", key: "record_date" },
        { title: "รหัสนักเรียน", key: "student_code" },
        { title: "ชื่อ-สกุล", key: "student_name" },
        { title: "สถานะการมาเรียน", key: "attendance_status_name" },
        { title: "ดูรายละเอียด", key: "view", align: "center" },
      ]
    : [
        { title: "วันที่", value: "record_date" },
        { title: "รหัสนักเรียน", value: "student_code" },
        { title: "ชื่อ-สกุล", value: "student_name" },
        { title: "ห้อง", value: "classroom_name" },
        { title: "ดูรายละเอียด", key: "view", align: "center" },
      ]
);

const showDatePickerFrom = ref(false);
const selectedDateFrom = ref(null);
const displayDateFrom = ref("");

function updateDisplayFrom(val) {
  if (!val) {
    displayDateFrom.value = "";
    return;
  }
  displayDateFrom.value = formatThaiDate(val);
  filters.value.date_from = formatDateToServer(val);
  showDatePickerFrom.value = false;
}

const showDatePickerTo = ref(false);
const selectedDateTo = ref(null);
const displayDateTo = ref("");

function updateDisplayTo(val) {
  if (!val) {
    displayDateTo.value = "";
    return;
  }
  displayDateTo.value = formatThaiDate(val);
  filters.value.date_to = formatDateToServer(val);
  showDatePickerTo.value = false;
}

function formatThaiDate(date) {
  if (!date) return "-";
  const d = new Date(date);
  const day = String(d.getDate()).padStart(2, "0");
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const year = d.getFullYear() + 543;
  return `${day}/${month}/${year}`;
}

function formatDateToServer(date) {
  const d = new Date(date);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

const statusOptions = [
  { value: "present", name: "เข้าเรียน" },
  { value: "home", name: "กลับบ้าน" },
  { value: "absent", name: "ขาด" },
  { value: "leave", name: "ลา" },
  { value: "sick", name: "ป่วย" },
];

function viewRecord(row) {
  selectedRecord.value = row.raw ?? row;
  dialogOpen.value = true;
}

const filters = ref({
  student_code: "",
  student_name: "",
  date_from: null,
  date_to: null,
  attendance_status: null,
});

const items = ref([]);

async function fetchRecords() {
  recordType.value = props.type;

  try {
    const token = localStorage.getItem("access_token");

    const endpoint =
      recordType.value === "health"
        ? "/history_health_records"
        : "/history_behavior_records";

    const response = await axios.get(`${API_BASE_URL}` + endpoint, {
      headers: { Authorization: `Bearer ${token}` },
      params: {
        ...filters.value,
      },
    });

    items.value =
      recordType.value === "health"
        ? response.data.health_records
        : response.data.behavior_records;
  } catch (e) {
    console.error("fetchRecords error:", e);
    items.value = [];
  }
}

async function refetch() {
  await fetchRecords();
}

async function onSearch() {
  await refetch();
}

function onReset() {
  filters.value = {
    student_code: "",
    student_name: "",
    date_from: null,
    date_to: null,
    attendance_status: null,
  };
  displayDateFrom.value = "";
  displayDateTo.value = "";
  refetch();
}

onMounted(() => {
  const token = localStorage.getItem("access_token");
  if (!token) {
    router.push("/login");
    return;
  }
  refetch();
});

onMounted(refetch);
watch(() => props.type, refetch);

const goBack = () => {
  if (recordType.value === "health") {
    router.push("/health");
  } else {
    router.push("/behavior");
  }
  // router.push("/home");
};
</script>
