// src/composables/useApi.js
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:3000/api', // 可根据实际后端端口调整
  timeout: 10000,
});

// 响应拦截，自动解包统一格式
api.interceptors.response.use(
  (response) => {
    if (response.data && typeof response.data === 'object' && 'status' in response.data) {
      if (response.data.status === 0) {
        return response.data.data;
      } else {
        // 业务错误
        return Promise.reject({
          status: response.data.status,
          message: response.data.message,
          data: response.data.data,
        });
      }
    }
    return response.data;
  },
  (error) => Promise.reject(error)
);

export default api;
