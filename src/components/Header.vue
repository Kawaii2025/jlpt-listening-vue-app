<template>
  <header 
    class="bg-white shadow-sm sticky top-0 z-50 transition-all duration-300" 
    :class="{ 'py-2 shadow': scrolled, 'py-4 shadow-sm': !scrolled }"
    id="navbar"
  >
    <div class="container mx-auto px-4 py-4 flex justify-between items-center">
      <div class="flex items-center space-x-2">
        <i class="fa fa-language text-primary text-2xl"></i>
        <h1 class="text-xl md:text-2xl font-bold bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent">
          日语听力练习
        </h1>
      </div>
      <nav class="hidden md:flex items-center space-x-6">
        <a href="#" class="text-primary font-medium hover:text-primary/80 transition-colors">首页</a>
        <a href="#" class="text-neutral-700 hover:text-primary transition-colors">练习历史</a>
        <a href="#" class="text-neutral-700 hover:text-primary transition-colors">学习资源</a>
        <a href="#" class="text-neutral-700 hover:text-primary transition-colors">关于</a>
      </nav>
      <button 
        class="md:hidden text-neutral-700 focus:outline-none" 
        id="mobile-menu-button"
        @click="toggleMobileMenu"
      >
        <i class="fa fa-bars text-xl"></i>
      </button>
    </div>
    <!-- 移动端菜单 -->
    <div 
      class="md:hidden" 
      :class="{ 'hidden': !isMobileMenuOpen, 'block': isMobileMenuOpen }"
      id="mobile-menu"
    >
      <div class="container mx-auto px-4 py-3 flex flex-col space-y-3">
        <a href="#" class="text-primary font-medium py-2 hover:bg-gray-50 px-2 rounded">首页</a>
        <a href="#" class="text-neutral-700 py-2 hover:bg-gray-50 px-2 rounded">练习历史</a>
        <a href="#" class="text-neutral-700 py-2 hover:bg-gray-50 px-2 rounded">学习资源</a>
        <a href="#" class="text-neutral-700 py-2 hover:bg-gray-50 px-2 rounded">关于</a>
      </div>
    </div>
  </header>
</template>

<script>
import { defineComponent, ref, onMounted, onUnmounted } from 'vue'

export default defineComponent({
  name: 'Header',
  setup() {
    const scrolled = ref(false)
    const isMobileMenuOpen = ref(false)

    const handleScroll = () => {
      scrolled.value = window.scrollY > 10
    }

    const toggleMobileMenu = () => {
      isMobileMenuOpen.value = !isMobileMenuOpen.value
    }

    onMounted(() => {
      window.addEventListener('scroll', handleScroll)
    })

    onUnmounted(() => {
      window.removeEventListener('scroll', handleScroll)
    })

    return {
      scrolled,
      isMobileMenuOpen,
      toggleMobileMenu
    }
  }
})
</script>