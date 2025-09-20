<template>
  <v-dialog v-model="model" persistent :max-width="850">
    <v-card style="background-color: #ffffff; color: black">
      <v-toolbar flat color="brown">
        <v-card-title class="text-h6">
          {{ title }}
        </v-card-title>
      </v-toolbar>

      <v-divider />

      <v-card-text>
        <v-row dense>
          <v-col cols="12" sm="6">
            <v-text-field
              label="วันที่"
              :model-value="formatDate(record?.record_date)"
              readonly
              variant="outlined"
              prepend-inner-icon="mdi-calendar"
            />
          </v-col>
          <v-col cols="12" sm="6"></v-col>
          <v-col cols="12" sm="6">
            <v-text-field
              label="ชื่อนักเรียน"
              :model-value="record?.student_fullname"
              readonly
              variant="outlined"
            />
          </v-col>
          <template v-if="type === 'health'">
            <v-col cols="12" sm="6">
              <v-text-field
                label="อุณหภูมิร่างกาย"
                :model-value="
                  record.body_temperature ? record.body_temperature : '-'
                "
                variant="outlined"
                readonly
              />
            </v-col>
            <v-col cols="12" sm="12">
              <v-card variant="outlined" class="mx-auto" max-width="100%">
                <v-card-title style="font-size: 1.1rem">
                  สถานะการมาเรียน
                </v-card-title>
                <v-card-text>
                  <v-btn-toggle
                    :model-value="record?.attendance_status"
                    mandatory
                    divided
                    color="primary"
                    base-color="#e0e0e0"
                  >
                    {{ record?.attendance_status }}
                    <v-btn readonly value="present" style="font-size: 1rem">
                      เข้าเรียน
                    </v-btn>
                    <v-btn readonly value="home" style="font-size: 1rem">
                      กลับบ้าน
                    </v-btn>
                    <v-btn readonly value="absent" style="font-size: 1rem">
                      ขาด
                    </v-btn>
                    <v-btn readonly value="leave" style="font-size: 1rem">
                      ลา
                    </v-btn>
                    <v-btn readonly value="sick" style="font-size: 1rem">
                      ป่วย
                    </v-btn>
                  </v-btn-toggle>
                </v-card-text>
              </v-card>
            </v-col>
            <v-col cols="12" sm="12">
              <v-card variant="outlined" class="mx-auto" max-width="100%">
                <v-card-title style="font-size: 1.1rem">
                  ตรวจร่างกายนักเรียน
                </v-card-title>
                <v-card-text>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="2"
                      align-self="center"
                      style="font-size: 1rem"
                    >
                      ตรวจเล็บ
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-btn-toggle
                        :model-value="record.nails_status"
                        mandatory
                        divided
                        color="primary"
                        base-color="#e0e0e0"
                      >
                        <v-btn :value="true" readonly>
                          <v-icon icon="mdi-check-bold" />
                        </v-btn>
                        <v-btn :value="false" readonly>
                          <v-icon icon="mdi-close-thick" />
                        </v-btn>
                      </v-btn-toggle>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="2"
                      align-self="center"
                      style="font-size: 1rem"
                    >
                      ตรวจผม
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-btn-toggle
                        :model-value="record.hair_status"
                        mandatory
                        divided
                        color="primary"
                        base-color="#e0e0e0"
                      >
                        <v-btn :value="true" readonly>
                          <v-icon icon="mdi-check-bold" />
                        </v-btn>
                        <v-btn :value="false" readonly>
                          <v-icon icon="mdi-close-thick" />
                        </v-btn>
                      </v-btn-toggle>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="2"
                      align-self="center"
                      style="font-size: 1rem"
                    >
                      ตรวจฟัน
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-btn-toggle
                        :model-value="record.teeth_status"
                        mandatory
                        divided
                        color="primary"
                        base-color="#e0e0e0"
                      >
                        <v-btn :value="true" readonly>
                          <v-icon icon="mdi-check-bold" />
                        </v-btn>
                        <v-btn :value="false" readonly>
                          <v-icon icon="mdi-close-thick" />
                        </v-btn>
                      </v-btn-toggle>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="2"
                      align-self="center"
                      style="font-size: 1rem"
                    >
                      ตรวจร่างกาย
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-btn-toggle
                        :model-value="record.body_status"
                        mandatory
                        divided
                        color="primary"
                        base-color="#e0e0e0"
                      >
                        <v-btn :value="true" readonly>
                          <v-icon icon="mdi-check-bold" />
                        </v-btn>
                        <v-btn :value="false" readonly>
                          <v-icon icon="mdi-close-thick" />
                        </v-btn>
                      </v-btn-toggle>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="2"
                      align-self="center"
                      style="font-size: 1rem"
                    >
                      ตรวจตา
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-btn-toggle
                        :model-value="record.eye_status"
                        mandatory
                        divided
                        color="primary"
                        base-color="#e0e0e0"
                      >
                        <v-btn :value="true" readonly>
                          <v-icon icon="mdi-check-bold" />
                        </v-btn>
                        <v-btn :value="false" readonly>
                          <v-icon icon="mdi-close-thick" />
                        </v-btn>
                      </v-btn-toggle>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="2"
                      align-self="center"
                      style="font-size: 1rem"
                    >
                      ตรวจจมูก
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-btn-toggle
                        :model-value="record.nose_status"
                        mandatory
                        divided
                        color="primary"
                        base-color="#e0e0e0"
                      >
                        <v-btn :value="true" readonly>
                          <v-icon icon="mdi-check-bold" />
                        </v-btn>
                        <v-btn :value="false" readonly>
                          <v-icon icon="mdi-close-thick" />
                        </v-btn>
                      </v-btn-toggle>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="2"
                      align-self="center"
                      style="font-size: 1rem"
                    >
                      ตรวจหู
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-btn-toggle
                        :model-value="record.ear_status"
                        mandatory
                        divided
                        color="primary"
                        base-color="#e0e0e0"
                      >
                        <v-btn :value="true" readonly>
                          <v-icon icon="mdi-check-bold" />
                        </v-btn>
                        <v-btn :value="false" readonly>
                          <v-icon icon="mdi-close-thick" />
                        </v-btn>
                      </v-btn-toggle>
                    </v-col>
                  </v-row>
                </v-card-text>
              </v-card>
            </v-col>
          </template>

          <!-- BEHAVIOR specific -->
          <template v-else>
            <v-col cols="12" sm="6">
              <v-text-field
                :model-value="record.school_name"
                label="ศพด."
                readonly
                variant="outlined"
              />
            </v-col>
            <v-col cols="12" sm="6">
              <v-text-field
                :model-value="record.class_name"
                label="ระดับชั้น"
                readonly
                variant="outlined"
              />
            </v-col>
            <v-col cols="12" sm="6">
              <v-text-field
                :model-value="record.classroom_name"
                label="ห้อง"
                readonly
                variant="outlined"
              />
            </v-col>
            <v-col cols="12" sm="12">
              <v-card variant="outlined" class="mx-auto" max-width="100%">
                <v-card-title style="font-size: 1.1rem">
                  พฤติกรรม
                </v-card-title>
                <v-card-text>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="2"
                      align-self="center"
                      style="font-size: 1rem"
                    >
                      การดื่มนม
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-btn-toggle
                        :model-value="record.milk_status"
                        mandatory
                        divided
                        color="primary"
                        base-color="#e0e0e0"
                      >
                        <v-btn readonly value="yes" style="font-size: 1rem">
                          ดื่ม
                        </v-btn>
                        <v-btn readonly value="no" style="font-size: 1rem">
                          ไม่ดื่ม
                        </v-btn>
                      </v-btn-toggle>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="2"
                      align-self="center"
                      style="font-size: 1rem"
                    >
                      อาหารกลางวัน
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-btn-toggle
                        :model-value="record.lunch_status"
                        mandatory
                        divided
                        color="primary"
                        base-color="#e0e0e0"
                      >
                        <v-btn readonly value="refill" style="font-size: 1rem">
                          เติม
                        </v-btn>
                        <v-btn readonly value="clear" style="font-size: 1rem">
                          หมด
                        </v-btn>
                        <v-btn
                          readonly
                          value="leftover"
                          style="font-size: 1rem"
                        >
                          ไม่หมด
                        </v-btn>
                      </v-btn-toggle>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="2"
                      align-self="center"
                      style="font-size: 1rem"
                    >
                      อาหารว่าง
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-btn-toggle
                        :model-value="record.snack_status"
                        mandatory
                        divided
                        color="primary"
                        base-color="#e0e0e0"
                      >
                        <v-btn readonly value="yes" style="font-size: 1rem">
                          ทาน
                        </v-btn>
                        <v-btn readonly value="no" style="font-size: 1rem">
                          ไม่ทาน
                        </v-btn>
                      </v-btn-toggle>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="2"
                      align-self="center"
                      style="font-size: 1rem"
                    >
                      แปรงฟัน
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-btn-toggle
                        :model-value="record.brushing_status"
                        mandatory
                        divided
                        color="primary"
                        base-color="#e0e0e0"
                      >
                        <v-btn readonly value="yes" style="font-size: 1rem">
                          แปรง
                        </v-btn>
                        <v-btn readonly value="no" style="font-size: 1rem">
                          ไม่แปรง
                        </v-btn>
                      </v-btn-toggle>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="2"
                      align-self="center"
                      style="font-size: 1rem"
                    >
                      พักผ่อน
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-btn-toggle
                        :model-value="record.sleeping_status"
                        mandatory
                        divided
                        color="primary"
                        base-color="#e0e0e0"
                      >
                        <v-btn readonly value="full" style="font-size: 1rem">
                          หลับนาน
                        </v-btn>
                        <v-btn readonly value="some" style="font-size: 1rem">
                          หลับได้บ้าง
                        </v-btn>
                        <v-btn readonly value="no" style="font-size: 1rem">
                          ไม่หลับ
                        </v-btn>
                      </v-btn-toggle>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col
                      cols="12"
                      sm="2"
                      align-self="center"
                      style="font-size: 1rem"
                    >
                      การขับถ่าย
                    </v-col>
                    <v-col cols="12" sm="8">
                      <v-btn-toggle
                        :model-value="record.toilet_status"
                        mandatory
                        divided
                        color="primary"
                        base-color="#e0e0e0"
                      >
                        <v-btn readonly value="yes" style="font-size: 1rem">
                          ปกติ
                        </v-btn>
                        <v-btn readonly value="no" style="font-size: 1rem">
                          ไม่ปกติ
                        </v-btn>
                      </v-btn-toggle>
                    </v-col>
                  </v-row>
                </v-card-text>
              </v-card>
            </v-col>
          </template>

          <v-col cols="12" sm="6">
            <v-text-field
              :model-value="record.notes ? record.notes : '-'"
              label="หมายเหตุ"
              variant="outlined"
              readonly
            />
          </v-col>

          <template v-if="type === 'health'">
            <v-col cols="12" sm="12">
              <v-card variant="outlined" class="mx-auto" max-width="100%">
                <v-card-title style="font-size: 1.1rem">
                  รูปภาพนักเรียน
                </v-card-title>
                <v-card-text>
                  <!-- รูปตัวอย่าง -->
                  <div v-if="record?.student_photo" class="mt-2 text-center">
                    <v-img
                      :src="
                        getStudentImageUrl(
                          record.photo_path,
                          record.student_photo
                        )
                      "
                      max-width="250"
                      max-height="250"
                      class="mx-auto"
                      style="border-radius: 12px; border: 1px solid #ccc"
                    />
                  </div>

                  <!-- fallback ถ้าไม่มีภาพเลย -->
                  <div v-else class="text-grey mt-2 text-center">
                    ยังไม่มีรูปภาพ
                  </div>
                </v-card-text>
              </v-card>
            </v-col>
          </template>
        </v-row>
      </v-card-text>

      <v-divider />

      <v-card-actions class="justify-end">
        <slot name="actions">
          <v-btn variant="text" @click="close">ปิด</v-btn>
        </slot>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { computed } from "vue";
import { API_BASE_URL } from "@/assets/config";

const props = defineProps({
  modelValue: { type: Boolean, required: true },
  type: { type: String, default: "health" }, // 'health' | 'behavior'
  record: { type: Object, default: () => null },
});
const emit = defineEmits(["update:modelValue"]);

const model = computed({
  get: () => props.modelValue,
  set: (v) => emit("update:modelValue", v),
});

const title = computed(() =>
  props.type === "health"
    ? "รายละเอียดบันทึกสุขภาพ"
    : "รายละเอียดบันทึกพฤติกรรม"
);

function close() {
  emit("update:modelValue", false);
}

function formatDate(iso) {
  if (!iso) return "-";
  const d = new Date(iso);
  const dd = String(d.getDate()).padStart(2, "0");
  const mm = String(d.getMonth() + 1).padStart(2, "0");
  const yy = d.getFullYear() + 543;
  return `${dd}/${mm}/${yy}`; // DD/MM/YYYY
}

// ฟังก์ชันโหลดรูปภาพ
const getStudentImageUrl = (path, filename) => {
  if (!filename) return "";
  const imagePath = `${path}/${filename}`;
  return `${API_BASE_URL}/${imagePath}`; // เปลี่ยน URL ตามจริง
};
</script>
