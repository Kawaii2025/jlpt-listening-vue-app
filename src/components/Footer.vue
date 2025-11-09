<template>
  <footer class="bg-neutral-800 text-white py-8">
    <div class="container mx-auto px-4">
      <div class="flex flex-col md:flex-row justify-between items-center">
        <div class="mb-4 md:mb-0">
          <div class="flex items-center justify-center md:justify-start">
            <i class="fa fa-language text-primary text-xl mr-2"></i>
            <span class="font-bold">日语听力练习</span>
          </div>
          <p class="text-neutral-400 text-sm mt-2 text-center md:text-left">
            提升你的日语听力能力
          </p>
        </div>

        <div class="flex space-x-6">
          <a href="#" class="text-neutral-400 hover:text-white transition-colors">
            <i class="fa fa-github text-xl"></i>
          </a>
          <a href="#" class="text-neutral-400 hover:text-white transition-colors">
            <i class="fa fa-twitter text-xl"></i>
          </a>
          <a href="#" class="text-neutral-400 hover:text-white transition-colors">
            <i class="fa fa-envelope text-xl"></i>
          </a>
        </div>
      </div>

      <div class="border-t border-neutral-700 mt-6 pt-6 text-center text-neutral-500 text-sm">
        &copy; 2023 日语听力练习 | 一个帮助你提升日语听力的工具
      </div>
    </div>
  </footer>
</template>

<script>
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'Footer'
})
</script>