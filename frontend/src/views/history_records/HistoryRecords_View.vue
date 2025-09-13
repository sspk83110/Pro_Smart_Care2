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
        >
          <span>ข้อมูลย้อนหลัง — {{ title }}</span>
        </v-card-title>

        <v-card-text class="bg-white">
          <!-- ฟิลเตอร์ -->
          <v-form @submit.prevent="onSearch">
            <v-row>
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

              <v-col cols="12" md="3" v-if="recordType === 'behavior'">
                <v-text-field
                  v-model="filters.teacher_id"
                  label="รหัสครูผู้สอน"
                  clearable
                />
              </v-col>

              <v-col cols="12" md="3">
                <v-text-field
                  v-model="filters.keyword"
                  label="คำค้น (อาการ/พฤติกรรม/หมายเหตุ)"
                  clearable
                />
              </v-col>

              <v-col cols="12" md="3">
                <v-text-field
                  v-model="filters.date_from"
                  type="date"
                  label="วันที่เริ่ม"
                />
              </v-col>
              <v-col cols="12" md="3">
                <v-text-field
                  v-model="filters.date_to"
                  type="date"
                  label="วันที่สิ้นสุด"
                />
              </v-col>
            </v-row>

            <v-row class="mt-2" justify="end" no-gutters>
              <v-btn variant="text" class="mr-2" @click="onReset">ล้าง</v-btn>
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
              <td style="color: black">{{ item.record_date }}</td>
              <td style="color: black">{{ item.stuedent_code }}</td>
              <td style="color: black">{{ item.stuedent_name }}</td>
              <td style="color: black">{{ item.attendance_status || "-" }}</td>
              <td class="text-center">
                <v-avatar
                  color="yellow darken-2"
                  size="32"
                  class="elevation-1"
                  style="cursor: pointer"
                  @click="viewRecord(item)"
                >
                  <v-icon color="white" icon="mdi-pencil" size="20" />
                </v-avatar>
              </td>
              <td class="text-center">
                <v-avatar
                  color="red darken-1"
                  size="32"
                  class="elevation-1"
                  style="cursor: pointer"
                  @click="confirmRemove(item.teacher_id)"
                >
                  <v-icon color="white" icon="mdi-delete" size="20" />
                </v-avatar>
              </td>
            </tr>
          </template>

          <template #loading>
            <v-skeleton-loader type="table-row@5" />
          </template>

          <!-- คัสตอมคอลัมน์วันที่ (ต้องใช้ v-slot:[`item.xxx`]) -->
          <template v-slot:[`item.date`]="{ item }">
            {{ formatDate(item.raw?.date ?? item.date) }}
          </template>
        </v-data-table>

        <v-alert
          v-if="!loading && items.length === 0"
          type="info"
          variant="tonal"
          class="mt-6"
        >
          ไม่พบข้อมูล ลองปรับเงื่อนไขค้นหา/ช่วงวันที่
        </v-alert>
      </v-sheet>
    </v-container>
  </v-main>
</template>

<script setup>
import { ref, computed, watch, onMounted } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";
import AppBar from "@/views/appbar/AppBar.vue";

// Router
const router = useRouter();

const props = defineProps({
  type: { type: String, default: "health" }, // รับมาจาก props mapping ใน router
});

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
        { title: "สถานะการมาเรียน", key: "attendance_status" },
        { title: "ดูรายละเอียด", key: "view", align: "center" },
      ]
    : [
        { title: "วันที่", value: "record_date" },
        { title: "รหัสนักเรียน", value: "student_code" },
        { title: "ชื่อ-สกุล", value: "student_name" },
        { title: "พฤติกรรม", value: "behavior" },
        { title: "ดูรายละเอียด", key: "view", align: "center" },
      ]
);

const filters = ref({
  student_code: "",
  teacher_id: "",
  keyword: "",
  date_from: null,
  date_to: null,
});

const items = ref([]);
const total = ref(0);
const loading = ref(false);
const page = ref(1);
const itemsPerPage = ref(10);

async function fetchRecords(extraParams = {}) {
  recordType.value = props.type;

  loading.value = true;
  try {
    const endpoint =
      recordType.value === "behavior"
        ? "/api/behavior_records"
        : "/api/health_records";

    const { data } = await axios.get(endpoint, {
      params: {
        page: page.value,
        limit: itemsPerPage.value,
        ...filters.value,
        ...extraParams,
      },
    });

    items.value = data?.items || [];
    total.value = data?.total || 0;
  } catch (e) {
    console.error("fetchRecords error:", e);
    items.value = [];
    total.value = 0;
  } finally {
    loading.value = false;
  }
}

async function refetch() {
  await fetchRecords();
}

async function onSearch() {
  page.value = 1;
  await refetch();
}

function onReset() {
  filters.value = {
    student_code: "",
    teacher_id: "",
    keyword: "",
    date_from: null,
    date_to: null,
  };
  page.value = 1;
  refetch();
}

onMounted(() => {
  const token = localStorage.getItem("access_token");
  if (!token) {
    router.push("/login");
    return;
  }

  console.log("onMounted");
  refetch();
});

onMounted(refetch);
watch(() => props.type, refetch);

function formatDate(iso) {
  if (!iso) return "-";
  const d = new Date(iso);
  return d.toLocaleDateString();
}

const goBack = () => {
  router.push("/home");
};
</script>
