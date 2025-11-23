<template>
  <div class="flex flex-col items-center justify-center min-h-[40vh] text-center">
    <h1 class="text-3xl font-bold text-red-600 mb-4">404 - 页面未找到</h1>
    <p class="text-lg text-neutral-700 mb-6">路由未匹配任何组件，请检查路由配置或页面文件！</p>
    <router-link to="/" class="text-primary underline">返回首页</router-link>
  </div>
</template>

<script setup>
// 纯展示组件，无逻辑
</script>
