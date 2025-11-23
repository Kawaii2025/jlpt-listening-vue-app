<template>
  <main class="flex-grow container mx-auto px-4 py-8">
    <!-- 页面介绍 -->
    <section class="mb-10 text-center max-w-3xl mx-auto">
      <h2 class="text-[clamp(1.5rem,3vw,2.5rem)] font-bold text-neutral-800 mb-4 text-shadow">
        提升你的日语听力
      </h2>
    </section>

    <!-- 试卷/大题/小题下拉框 -->
    <div class="flex flex-wrap gap-4 mb-8 items-center justify-center">
      <div>
        <label class="block text-sm mb-1">选择试卷</label>
        <select v-model="selectedExam" @change="onExamChange" class="border rounded px-3 py-1 min-w-[180px]">
          <option value="" disabled>请选择试卷</option>
          <option v-for="exam in exams" :key="exam.id" :value="exam.id">{{ exam.name }}</option>
        </select>
      </div>
      <div>
        <label class="block text-sm mb-1">选择大题</label>
        <select v-model="selectedPart" :disabled="!selectedExam" @change="onPartChange" class="border rounded px-3 py-1 min-w-[180px]">
          <option value="" disabled>请选择大题</option>
          <option v-for="part in parts" :key="part.id" :value="part.id">{{ part.partName }}</option>
        </select>
      </div>
      <div>
        <label class="block text-sm mb-1">选择小题</label>
        <select v-model="selectedItem" :disabled="!selectedPart" @change="onItemChange" class="border rounded px-3 py-1 min-w-[180px]">
          <option value="" disabled>请选择小题</option>
          <option v-for="item in items" :key="item.id" :value="item.id">第{{ item.itemNum }}题</option>
        </select>
      </div>
    </div>
    
    <!-- 加载动画 -->
    <div v-if="loading" class="flex justify-center items-center py-16">
      <span class="text-primary text-lg flex items-center"><i class="fa fa-spinner fa-spin mr-2"></i>数据加载中...</span>
    </div>
    <!-- 结果显示区域 -->
    <section :class="{ 'hidden': !showResults || loading }" id="results-section" class="max-w-4xl mx-auto">
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
      :class="{ 'hidden': showResults || mixedText.trim() !== '' }" 
      id="empty-state" 
      class="max-w-4xl mx-auto py-16 text-center"
    >
      <div class="bg-white rounded-xl p-8 shadow-sm">
        <i class="fa fa-file-text-o text-5xl text-neutral-300 mb-4"></i>
        <h3 class="text-xl font-medium text-neutral-700 mb-2">还没有处理的文本</h3>
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
import { defineComponent, ref, onMounted } from 'vue'
import SentenceCard from './SentenceCard.vue'
import { useTextProcessing } from '../composables/useTextProcessing'
import api from '../composables/useApi'

export default defineComponent({
  name: 'MainContent',
  components: {
    SentenceCard,
  },
  emits: ['update-sentence'],
  setup(props, { emit }) {
  // 小题下拉相关
  const items = ref([])
  const selectedItem = ref("")
    // 大题下拉相关
    const parts = ref([])
    const selectedPart = ref("")
    const mixedText = ref(`大学の演劇サ一クルで女の学生と部長の男の学生が話しています。女の学生はこの後何
をしなければなりませんか。
女:鈴木さん。来週の新入生勧誘のためのサ一クル体験会、ポスタ一を見た人から早速
参加の申し込みが来てますね。
男:うん、準備進めないとね。当日来てくれた人には演劇を一部実際に体験してもらう
よね？その時に使うシ一ン、台本から候補選ぶのお願いしてたけど、どう?
女:はい。体験者が多くても使えそうなシンを3つピックアップしました。
男:じゃ、その中から僕が選んでセリフを印刷しておくよ。あと当日は受付とか誘導と
かみんなにも手伝ってもらうから誰が何を担当するか割り振ってほしいんだ。
女:わかりました。えっと、当日配る入部案内のチラシの準備は?
男：ああ、それは2年生に印刷してもらおうと思ってるんだ。僕から頼んでおくよ。
女：わかりました。
女の学生はこの後何をしなければなりませんか。`)

    const { splitByPeriod, extractAndRemoveGenderPrefix, showNotification } = useTextProcessing()
  const sentenceData = ref([])
  const loading = ref(false)
    const chineseSentences = ref([])
    const showResults = ref(false)
    const editModalData = ref({
      show: false,
      index: null,
      gender: '',
      japanese: '',
      chinese: ''
    })

    // 试卷下拉相关
    const exams = ref([])
    const selectedExam = ref("")

    // 页面加载时获取试卷列表
    onMounted(async () => {
      loading.value = true;
      try {
        const res = await api.get('/exams');
        exams.value = res.data || res;
      } catch (e) {
        // 若后端不可用，回退本地处理
        processText();
      } finally {
        loading.value = false;
      }
    });

    // 优化：无性别的句子继承前一个句子的性别
    const assignGenders = () => {
      for (let i = 0; i < sentenceData.value.length; i++) {
        if (!sentenceData.value[i].gender && i > 0) {
          for (let j = i - 1; j >= 0; j--) {
            if (sentenceData.value[j].gender) {
              sentenceData.value[i].gender = sentenceData.value[j].gender;
              break;
            }
          }
        }
      }
    }

    // 选择试卷后获取大题
    const onExamChange = async () => {
      selectedPart.value = "";
      parts.value = [];
      if (!selectedExam.value) return;
      loading.value = true;
      try {
        const res = await api.get(`/parts?examId=${selectedExam.value}`);
        parts.value = res.data || res;
      } finally {
        loading.value = false;
      }
    };

    // 选择大题后预留后续逻辑
    const onPartChange = () => {
      // 选择大题后，获取小题列表
      selectedItem.value = "";
      items.value = [];
      sentenceData.value = [];
      chineseSentences.value = [];
      showResults.value = false;
      if (!selectedPart.value) return;
      loading.value = true;
      api.get(`/items/byPart/${selectedPart.value}`)
        .then(res => {
          items.value = res.data || res;
        })
        .catch(() => {
          showNotification('获取小题失败', 'error');
        })
        .finally(() => {
          loading.value = false;
        });
    };

    // 选择小题后获取句子
    const onItemChange = () => {
      sentenceData.value = [];
      chineseSentences.value = [];
      showResults.value = false;
      if (!selectedItem.value) return;
      loading.value = true;
      api.get(`/sentences?itemId=${selectedItem.value}`)
        .then(res => {
          const rows = res.data || res;
          sentenceData.value = (rows.data || rows).map(row => ({
            text: row.text,
            gender: row.partName || '',
            errors: [],
            lastErrorRange: { start: 0, end: 0 },
            lastErrorToParticleRange: { start: 0, end: 0 },
            shortPlayRange: { start: 0, end: 0 }
          }));
          chineseSentences.value = Array(sentenceData.value.length).fill('');
          showResults.value = true;
        })
        .catch(() => {
          showNotification('获取句子失败', 'error');
        })
        .finally(() => {
          loading.value = false;
        });
    };


    // 处理文本的函数
    const processText = (text = mixedText.value) => {
      try {
        // 验证输入
        if (!text) {
          showNotification('请输入文本内容', 'warning');
          return;
        }
        if (text.length === 0) {
          showNotification('未检测到有效内容', 'warning');
          return;
        }
        // 只处理日语句子
        sentenceData.value = [];
        chineseSentences.value = [];
        // 直接按句号分割所有文本
        const sentences = splitByPeriod(text);
        sentences.forEach(sentence => {
          if (sentence.trim() !== '') {
            const { text: processedText, gender } = extractAndRemoveGenderPrefix(sentence);
            sentenceData.value.push({
              text: processedText,
              gender: gender,
              errors: [],
              lastErrorRange: { start: 0, end: 0 },
              lastErrorToParticleRange: { start: 0, end: 0 },
              shortPlayRange: { start: 0, end: 0 }
            });
            chineseSentences.value.push('');
          }
        });
        assignGenders();
        showResults.value = true;
        setTimeout(() => {
          const practiceContentAnchor = document.getElementById('practice-content');
          if (practiceContentAnchor) {
            const navbar = document.getElementById('navbar');
            const navbarHeight = navbar ? navbar.offsetHeight : 0;
            const elementTop = practiceContentAnchor.getBoundingClientRect().top + window.scrollY;
            window.scrollTo({
              top: elementTop - navbarHeight - 20,
              behavior: 'smooth'
            });
          }
        }, 100);
        showNotification(`已成功处理 ${sentenceData.value.length} 句日语`, 'success');
      } catch (error) {
        console.error('处理文本时出错:', error);
        showNotification('处理文本时发生错误，请检查输入格式', 'error');
      }
    }

    // 清空文本
    const clearText = () => {
      mixedText.value = '';
      sentenceData.value = [];
      chineseSentences.value = [];
      showResults.value = false;
    }

    // 焦点到文本区域
    const focusOnTextarea = () => {
      const textarea = document.getElementById('mixed-text');
      if (textarea) {
        textarea.focus();
      }
    }

    // 打开编辑模态框
    const openEditModal = (index) => {
      const sentence = sentenceData.value[index];
      const chinese = chineseSentences.value[index];

      const editData = {
        index: index,
        gender: sentence.gender || '',
        japanese: sentence.text,
        chinese: chinese
      };

      emit('openEditModal', editData);
    }

    const updateSentence = (data) => {
      const { index, gender, japanese, chinese } = data;
      if (index >= 0 && index < sentenceData.value.length) {
        // Update the sentence data
        sentenceData.value[index].text = japanese;
        sentenceData.value[index].gender = gender;
        chineseSentences.value[index] = chinese;
        
        // Show notification
        showNotification(`句子 ${index + 1} 已更新`, 'success');
      }
    };


    // 页面加载时从后端获取句子
    onMounted(async () => {
      loading.value = true;
      try {
        const res = await api.get('/sentences');
        // 兼容分页结构
        const rows = res.data || res;
        sentenceData.value = (rows.data || rows).map(row => ({
          text: row.text,
          gender: '',
          errors: [],
          lastErrorRange: { start: 0, end: 0 },
          lastErrorToParticleRange: { start: 0, end: 0 },
          shortPlayRange: { start: 0, end: 0 }
        }));
        chineseSentences.value = Array(sentenceData.value.length).fill('');
        showResults.value = true;
      } catch (e) {
        // 若后端不可用，回退本地处理
        processText();
      } finally {
        loading.value = false;
      }
    });

    return {
      mixedText,
      sentenceData,
      chineseSentences,
      showResults,
      loading,
      processText,
      clearText,
      showNotification,
      focusOnTextarea,
      openEditModal,
      updateSentence,
      exams,
      selectedExam,
      parts,
      selectedPart,
      items,
      selectedItem,
      onExamChange,
      onPartChange,
      onItemChange
    }
  }
})
</script>
