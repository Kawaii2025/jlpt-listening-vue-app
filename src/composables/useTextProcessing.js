import { ref } from 'vue'

// 日语常用助词列表
const japaneseParticles = ['は', 'が', 'を', 'に', 'で', 'と', 'から', 'まで', 'へ', 'の', 'より', 'や', 'か', 'も', 'ね', 'よ', 'って', 'な', 'だ', 'です', 'ます'];

export function useTextProcessing() {
  // 判断文本是否包含日语字符
  const containsJapanese = (text) => {
    const japaneseRegex = /[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FFF]/;
    return japaneseRegex.test(text);
  }

  // 按句号分割句子（。！？）并保留标点符号，也在性别标识处分割
  const splitByPeriod = (text) => {
    // 先去掉换行符（换行符之间没有真实的空格）
    const cleanedText = text.replace(/\n+/g, '').trim();

    // 先按句号、感叹号、问号分割，但保留标点符号
    let sentences = cleanedText.split(/(?<=[。！？])/);

    // 再按性别标识分割（女: 、男: 、女： 、男：）
    sentences = sentences.flatMap(sentence => {
      return sentence.split(/(?=[女男男女][：:])/);
    });

    return sentences
      .map(s => s.trim())
      .filter(s => s !== '');
  }

  // 提取并去除开头的性别标识
  const extractAndRemoveGenderPrefix = (text) => {
    const genderMatch = text.match(/^([男女男女])([:：])/);

    if (genderMatch) {
      const gender = genderMatch[1];
      const processedText = text.replace(/^[男女男女][:：]/, '').trim();
      return {
        text: processedText,
        gender: gender === '男' || gender === '男' ? 'male' : 'female'
      };
    }

    return {
      text: text.trim(),
      gender: null
    };
  }

  // 查找从指定位置开始的下一个助词位置
  const findNextParticlePosition = (text, startPos) => {
    // 从起始位置开始检查每个字符
    for (let i = startPos; i < text.length; i++) {
      // 检查当前字符是否是助词
      if (japaneseParticles.includes(text[i])) {
        return i;
      }

      // 检查是否是双字符助词（如"って"）
      if (i < text.length - 1) {
        const twoChars = text[i] + text[i + 1];
        if (japaneseParticles.includes(twoChars)) {
          return i + 1; // 返回双字符助词的结束位置
        }
      }
    }

    // 如果没有找到助词，返回文本末尾
    return text.length - 1;
  }

  // 查找从指定位置开始的第N个助词位置
  const findNthParticlePosition = (text, startPos, count) => {
    let particleCount = 0;
    let lastPosition = startPos;

    // 从起始位置开始检查每个字符
    for (let i = startPos; i < text.length; i++) {
      // 检查当前字符是否是助词
      if (japaneseParticles.includes(text[i])) {
        particleCount++;
        lastPosition = i;
        if (particleCount >= count) {
          return lastPosition;
        }
      }

      // 检查是否是双字符助词（如"って"）
      if (i < text.length - 1) {
        const twoChars = text[i] + text[i + 1];
        if (japaneseParticles.includes(twoChars)) {
          particleCount++;
          lastPosition = i + 1;
          if (particleCount >= count) {
            return lastPosition;
          }
          i++; // 跳过已处理的第二个字符
        }
      }
    }

    // 如果找到的助词不足N个，返回文本末尾
    return text.length - 1;
  }

  // 比较文本并记录错误位置
  const compareTexts = (userText, originalText) => {
    let userHtml = '';
    let correctHtml = '';
    let correctCount = 0;
    let errorPositions = []; // 记录错误位置
    const maxLength = Math.max(userText.length, originalText.length);

    for (let i = 0; i < maxLength; i++) {
      const userChar = i < userText.length ? userText[i] : '';
      const originalChar = i < originalText.length ? originalText[i] : '';

      if (userChar === originalChar && userChar !== '') {
        // 字符正确
        userHtml += `<span class="correct-char">${userChar}</span>`;
        correctHtml += `<span class="correct-char">${originalChar}</span>`;
        correctCount++;
      } else {
        // 字符错误，记录位置
        errorPositions.push(i);

        if (userChar && originalChar) {
          // 替换错误
          userHtml += `<span class="incorrect-char">${userChar}</span>`;
          correctHtml += `<span class="incorrect-char">${originalChar}</span>`;
        } else if (userChar && !originalChar) {
          // 插入错误
          userHtml += `<span class="extra-char">${userChar}</span>`;
        } else if (!userChar && originalChar) {
          // 删除错误
          userHtml += `<span class="missing-char"> </span>`;
          correctHtml += `<span class="missing-char">${originalChar}</span>`;
        }
      }
    }

    const accuracy = originalText.length > 0 ? (correctCount / originalText.length) * 100 : 0;
    const correct = accuracy === 100;

    return {
      userHtml: userHtml,
      correctHtml: correctHtml,
      accuracy: accuracy,
      correct: correct,
      errorPositions: errorPositions
    };
  }

  // 日语朗读函数
  const speakJapanese = (text, gender) => {
    try {
      // 停止任何正在进行的朗读
      window.speechSynthesis.cancel();

      const utterance = new SpeechSynthesisUtterance(text);
      utterance.lang = 'ja-JP';
      utterance.rate = 0.9; // 稍慢的语速，适合学习

      // 根据性别调整音调和音量
      if (gender === 'male') {
        utterance.pitch = 0.8; // 降低音调以显得更低沉（男性）
        utterance.volume = 1.0;
      } else if (gender === 'female') {
        utterance.pitch = 1.2; // 提高音调以显得更尖锐（女性）
        utterance.volume = 1.0;
      }

      // 尝试找到合适的语音
      const voices = window.speechSynthesis.getVoices();
      let selectedVoice = null;

      // 筛选日语语音
      const japaneseVoices = voices.filter(voice =>
        voice.lang.includes('ja') || voice.name.includes('Japanese')
      );

      if (japaneseVoices.length > 0) {
        // 根据性别选择语音
        if (gender === 'male') {
          selectedVoice = japaneseVoices.find(voice =>
            voice.name.toLowerCase().includes('male') ||
            voice.name.toLowerCase().includes('man') ||
            (voice.name.includes('Google') && !voice.name.includes('female'))
          );
        } else if (gender === 'female') {
          selectedVoice = japaneseVoices.find(voice =>
            voice.name.toLowerCase().includes('female') ||
            voice.name.toLowerCase().includes('woman') ||
            voice.name.includes('female')
          );
        }

        // 如果没有找到对应性别的语音，使用第一个日语语音
        if (!selectedVoice) {
          selectedVoice = japaneseVoices[0];
        }

        utterance.voice = selectedVoice;
      }

      window.speechSynthesis.speak(utterance);
    } catch (error) {
      console.error('语音合成失败:', error);
      showNotification('语音合成功能不可用，请检查浏览器设置', 'error');
    }
  }

  // 显示通知函数
  const showNotification = (message, type = 'info') => {
    // Remove any existing notifications
    const existingNotifications = document.querySelectorAll('.fixed.bottom-4.right-4');
    existingNotifications.forEach(notification => {
      if (notification.classList.contains('z-50')) {
        notification.remove();
      }
    });

    const notification = document.createElement('div');

    let bgColor, icon;
    switch (type) {
      case 'success':
        bgColor = 'bg-green-500';
        icon = 'fa-check-circle';
        break;
      case 'warning':
        bgColor = 'bg-yellow-500';
        icon = 'fa-exclamation-triangle';
        break;
      case 'error':
        bgColor = 'bg-red-500';
        icon = 'fa-times-circle';
        break;
      default:
        bgColor = 'bg-primary';
        icon = 'fa-info-circle';
    }

    notification.className = `fixed bottom-4 right-4 ${bgColor} text-white px-4 py-3 rounded-lg shadow-lg transform transition-all duration-300 translate-y-10 opacity-0 z-50 flex items-center`;
    notification.innerHTML = `
      <i class="fa ${icon} mr-2"></i>
      <span>${message}</span>
    `;

    document.body.appendChild(notification);

    // 显示动画
    setTimeout(() => {
      notification.classList.remove('translate-y-10', 'opacity-0');
    }, 10);

    // 自动消失
    setTimeout(() => {
      notification.classList.add('translate-y-10', 'opacity-0');
      setTimeout(() => {
        if (document.body.contains(notification)) {
          document.body.removeChild(notification);
        }
      }, 300);
    }, 3000);
  }

  return {
    containsJapanese,
    splitByPeriod,
    extractAndRemoveGenderPrefix,
    findNextParticlePosition,
    findNthParticlePosition,
    compareTexts,
    speakJapanese,
    showNotification
  }
}