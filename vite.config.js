import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  build: {
    outDir: 'dist'
  },
  // Base URL for GitHub Pages deployment
  base: '/jlpt-listening-qwen-vue-app/'
})