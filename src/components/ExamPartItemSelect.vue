<template>
  <div class="flex flex-wrap gap-6 mb-10 items-center justify-center">
    <div class="flex flex-col items-start">
      <label class="block text-sm font-medium text-neutral-700 mb-1">选择试卷</label>
      <select
        v-model="localSelectedExam"
        @change="handleExamChange"
        class="min-w-[180px] px-4 py-2 rounded-lg border border-neutral-300 shadow-sm bg-white text-neutral-800 focus:ring-2 focus:ring-primary focus:border-primary transition-all duration-150 outline-none hover:border-primary/70 hover:shadow-md disabled:bg-neutral-100 disabled:text-neutral-400"
      >
        <option value="" disabled>请选择试卷</option>
        <option v-for="exam in exams" :key="exam.id" :value="exam.id">{{ exam.name }}</option>
      </select>
    </div>
    <div class="flex flex-col items-start">
      <label class="block text-sm font-medium text-neutral-700 mb-1">选择大题</label>
      <select
        v-model="localSelectedPart"
        :disabled="!localSelectedExam"
        @change="handlePartChange"
        class="min-w-[180px] px-4 py-2 rounded-lg border border-neutral-300 shadow-sm bg-white text-neutral-800 focus:ring-2 focus:ring-primary focus:border-primary transition-all duration-150 outline-none hover:border-primary/70 hover:shadow-md disabled:bg-neutral-100 disabled:text-neutral-400"
      >
        <option value="" disabled>请选择大题</option>
        <option v-for="part in parts" :key="part.id" :value="part.id">{{ part.partName }}</option>
      </select>
    </div>
    <div class="flex flex-col items-start">
      <label class="block text-sm font-medium text-neutral-700 mb-1">选择小题</label>
      <select
        v-model="localSelectedItem"
        :disabled="!localSelectedPart"
        @change="handleItemChange"
        class="min-w-[180px] px-4 py-2 rounded-lg border border-neutral-300 shadow-sm bg-white text-neutral-800 focus:ring-2 focus:ring-primary focus:border-primary transition-all duration-150 outline-none hover:border-primary/70 hover:shadow-md disabled:bg-neutral-100 disabled:text-neutral-400"
      >
        <option value="" disabled>请选择小题</option>
        <option v-for="item in items" :key="item.id" :value="item.id">第{{ item.itemNum }}题</option>
      </select>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue'
import api from '../composables/useApi'

const props = defineProps({
  modelValue: Object // { selectedExam, selectedPart, selectedItem }
})
const emit = defineEmits(['update:modelValue'])

const exams = ref([])
const parts = ref([])
const items = ref([])
const localSelectedExam = ref(props.modelValue?.selectedExam || '')
const localSelectedPart = ref(props.modelValue?.selectedPart || '')
const localSelectedItem = ref(props.modelValue?.selectedItem || '')

const fetchExams = async () => {
  const res = await api.get('/exams')
  exams.value = res.data || res
}
const fetchParts = async (examId) => {
  if (!examId) { parts.value = []; return }
  const res = await api.get(`/parts?examId=${examId}`)
  parts.value = res.data || res
}
const fetchItems = async (partId) => {
  if (!partId) { items.value = []; return }
  const res = await api.get(`/items/byPart/${partId}`)
  items.value = res.data || res
}

const updateModel = () => {
  emit('update:modelValue', {
    selectedExam: localSelectedExam.value,
    selectedPart: localSelectedPart.value,
    selectedItem: localSelectedItem.value
  })
}

const handleExamChange = async () => {
  localSelectedPart.value = ''
  localSelectedItem.value = ''
  await fetchParts(localSelectedExam.value)
  items.value = []
  updateModel()
}
const handlePartChange = async () => {
  localSelectedItem.value = ''
  await fetchItems(localSelectedPart.value)
  updateModel()
}
const handleItemChange = () => {
  updateModel()
}

onMounted(async () => {
  await fetchExams()
  if (localSelectedExam.value) await fetchParts(localSelectedExam.value)
  if (localSelectedPart.value) await fetchItems(localSelectedPart.value)
})

watch(() => props.modelValue?.selectedExam, (val) => { localSelectedExam.value = val })
watch(() => props.modelValue?.selectedPart, (val) => { localSelectedPart.value = val })
watch(() => props.modelValue?.selectedItem, (val) => { localSelectedItem.value = val })
</script>
