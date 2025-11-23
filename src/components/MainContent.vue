<template>
  <main class="flex-grow container mx-auto px-4 py-8">
    <!-- 页面介绍 -->
    <section class="mb-10 text-center max-w-3xl mx-auto">
      <h2
        class="text-[clamp(1.5rem,3vw,2.5rem)] font-bold text-neutral-800 mb-4 text-shadow"
      >
        提升你的日语听力
      </h2>
    </section>

    <!-- 试卷/大题/小题下拉框 -->
    <ExamPartItemSelect v-model="selectState" />

    <!-- 加载动画 -->
    <div v-if="loading" class="flex justify-center items-center py-16">
      <span class="text-primary text-lg flex items-center"
        ><i class="fa fa-spinner fa-spin mr-2"></i>数据加载中...</span
      >
    </div>
    <!-- 结果显示区域 -->
    <section
      :class="{ hidden: !showResults || loading }"
      id="results-section"
      class="max-w-4xl mx-auto"
    >
      <div id="practice-content" class="flex justify-between items-center mb-6">
        <h3 class="text-xl font-semibold flex items-center">
          <i class="fa fa-list-alt text-primary mr-2"></i>练习内容
        </h3>
        <div class="text-sm text-neutral-600">
          <span id="sentence-count">{{ sentenceData.length }}</span> 组句子
        </div>
      </div>

      <!-- 句子列表 -->
      <div id="sentences-container" class="space-y-8">
        <SentenceCard
          v-for="(sentence, index) in sentenceData"
          :key="index"
          :index="index"
          :sentence="sentence"
          :chinese-sentence="chineseSentences[index]"
          :on-edit="openEditModal"
        />
      </div>
    </section>

    <!-- 空状态提示 -->
    <section
      :class="{ hidden: showResults }"
      id="empty-state"
      class="max-w-4xl mx-auto py-16 text-center"
    >
      <div class="bg-white rounded-xl p-8 shadow-sm">
        <i class="fa fa-file-text-o text-5xl text-neutral-300 mb-4"></i>
        <h3 class="text-xl font-medium text-neutral-700 mb-2">
          还没有处理的文本
        </h3>
        <p class="text-neutral-500 mb-6">
          请在上方交替输入日语和中文内容，然后点击"处理文本"按钮开始练习
        </p>
        <button
          @click="focusOnTextarea"
          class="px-6 py-2 bg-primary hover:bg-primary/90 text-white rounded-lg shadow-sm hover:shadow transition-all"
        >
          开始练习
        </button>
      </div>
    </section>
  </main>
</template>

<script>
import { defineComponent, ref, watch } from 'vue';
import SentenceCard from './SentenceCard.vue';
import ExamPartItemSelect from './ExamPartItemSelect.vue';
import { useTextProcessing } from '../composables/useTextProcessing';
import api from '../composables/useApi';

export default defineComponent({
  name: 'MainContent',
  components: {
    SentenceCard,
    ExamPartItemSelect,
  },
  emits: ['update-sentence'],
  setup(props, { emit }) {
    const selectState = ref({
      selectedExam: '',
      selectedPart: '',
      selectedItem: '',
    });
    const sentenceData = ref([]);
    const chineseSentences = ref([]);
    const loading = ref(false);
    const showResults = ref(false);

    // 监听下拉框选中项变化，自动请求句子
    watch(
      () => selectState.value.selectedItem,
      async (itemId) => {
        if (!itemId) {
          sentenceData.value = [];
          chineseSentences.value = [];
          showResults.value = false;
          return;
        }
        loading.value = true;
        try {
          const res = await api.get(`/items/${itemId}/sentences`);
          const rows = res.data || res;
          sentenceData.value = (rows.data || rows);
          chineseSentences.value = Array(sentenceData.value.length).fill('');
          showResults.value = true;
        } finally {
          loading.value = false;
        }
      }
    );

    return {
      selectState,
      sentenceData,
      chineseSentences,
      showResults,
      loading,
    };
  },
});
</script>
