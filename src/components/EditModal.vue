<template>
  <div 
    v-if="show" 
    class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4"
    @click="handleBackdropClick"
  >
    <div class="bg-white rounded-xl shadow-lg w-full max-w-lg">
      <div class="p-6 border-b border-neutral-200">
        <div class="flex justify-between items-center">
          <h3 class="text-lg font-semibold text-neutral-800">编辑句子</h3>
          <button @click="closeModal" class="text-neutral-500 hover:text-neutral-800">
            <i class="fa fa-times"></i>
          </button>
        </div>
      </div>
      <div class="p-6">
        <input type="hidden" id="edit-sentence-index">

        <div class="mb-4">
          <label for="edit-gender" class="block text-sm font-medium text-neutral-700 mb-1">
            性别
          </label>
          <select 
            id="edit-gender" 
            v-model="localData.gender"
            class="w-full px-3 py-2 border border-neutral-200 rounded-lg focus:ring-2 focus:ring-primary/50 focus:border-primary"
          >
            <option value="">无</option>
            <option value="male">男性</option>
            <option value="female">女性</option>
          </select>
        </div>

        <div class="mb-4">
          <label for="edit-japanese" class="block text-sm font-medium text-neutral-700 mb-1">
            日语句子
          </label>
          <textarea 
            id="edit-japanese" 
            v-model="localData.japanese"
            rows="3" 
            class="w-full px-3 py-2 border border-neutral-200 rounded-lg focus:ring-2 focus:ring-primary/50 focus:border-primary font-japanese"
          ></textarea>
        </div>

        <div>
          <label for="edit-chinese" class="block text-sm font-medium text-neutral-700 mb-1">
            中文翻译
          </label>
          <textarea 
            id="edit-chinese" 
            v-model="localData.chinese"
            rows="3" 
            class="w-full px-3 py-2 border border-neutral-200 rounded-lg focus:ring-2 focus:ring-primary/50 focus:border-primary"
          ></textarea>
        </div>
      </div>
      <div class="p-4 bg-neutral-50 rounded-b-xl flex justify-end gap-3">
        <button @click="closeModal" class="px-4 py-2 border border-neutral-300 rounded-lg text-neutral-700 hover:bg-neutral-100 transition-all">
          取消
        </button>
        <button @click="saveEdit" class="px-4 py-2 bg-primary hover:bg-primary/90 text-white rounded-lg shadow-sm hover:shadow transition-all">
          保存
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { defineComponent, ref, watch } from 'vue'

export default defineComponent({
  name: 'EditModal',
  props: {
    show: {
      type: Boolean,
      default: false
    },
    editData: {
      type: Object,
      default: () => ({
        index: null,
        gender: '',
        japanese: '',
        chinese: ''
      })
    }
  },
  emits: ['close', 'save'],
  setup(props, { emit }) {
    const localData = ref({ ...props.editData })

    // Watch for changes in props.editData and update localData
    watch(() => props.editData, (newData) => {
      localData.value = { ...newData }
    }, { deep: true })

    const closeModal = () => {
      emit('close')
    }

    const saveEdit = () => {
      emit('save', {
        index: props.editData.index,
        gender: localData.value.gender,
        japanese: localData.value.japanese,
        chinese: localData.value.chinese
      })
      closeModal()
    }

    const handleBackdropClick = (event) => {
      if (event.target.classList.contains('fixed')) {
        closeModal()
      }
    }

    return {
      localData,
      closeModal,
      saveEdit,
      handleBackdropClick
    }
  }
})
</script>