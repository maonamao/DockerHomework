import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

const app = createApp(App)

// 全局错误处理
app.config.errorHandler = (err, vm, info) => {
  console.error('Vue错误:', err)
  console.error('发生在组件:', vm)
  console.error('位置:', info)
  // 可以在这里添加错误上报
}

app.use(router)
app.mount('#app')

// 全局变量
window.appVersion = '1.0.0'