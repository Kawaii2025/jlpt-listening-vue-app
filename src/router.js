import { createRouter, createWebHistory } from 'vue-router';
import MainContent from './components/MainContent.vue';
import TextInputSection from './components/TextInputSection.vue';
import NotFound from './components/NotFound.vue';

const routes = [
  { path: '/', component: MainContent },
  { path: '/input', component: TextInputSection },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: NotFound
  }
];

const router = createRouter({
  history: createWebHistory(import.meta.env.VITE_ROUTER_BASE),
  routes,
});

export default router;
