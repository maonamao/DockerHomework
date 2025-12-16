import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import axios from 'axios'

Vue.config.productionTip = false
Vue.use(ElementUI)

// 配置axios
axios.defaults.baseURL = process.env.VUE_APP_API_URL
axios.defaults.timeout = 30000

// 请求拦截器
axios.interceptors.request.use(
  config => {
    // 添加token等
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
axios.interceptors.response.use(
  response => {
    return response.data
  },
  error => {
    if (error.response) {
      switch (error.response.status) {
        case 401:
          // 跳转到登录页
          router.push('/login')
          break
        case 403:
          Vue.prototype.$message.error('权限不足')
          break
        case 500:
          Vue.prototype.$message.error('服务器错误')
          break
        default:
          Vue.prototype.$message.error(error.response.data.message || '请求失败')
      }
    }
    return Promise.reject(error)
  }
)

Vue.prototype.$axios = axios

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
