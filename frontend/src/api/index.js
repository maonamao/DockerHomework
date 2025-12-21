import axios from 'axios'

// 创建axios实例
// 本地开发时使用代理或直接连接后端
const apiClient = axios.create({
  // 方案1：直接连接后端（端口8080）
  baseURL: 'http://localhost:8080/api',
  // 方案2：使用Vue开发服务器代理（需要vue.config.js配置）
  // baseURL: '/api',
  headers: {
    'Content-Type': 'application/json'
  },
  timeout: 10000
})

// 请求拦截器
apiClient.interceptors.request.use(
  config => {
    // 可以在这里添加token等
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
apiClient.interceptors.response.use(
  response => {
    return response
  },
  error => {
    console.error('API请求错误:', error)
    if (error.response) {
      switch (error.response.status) {
        case 401:
          alert('未授权，请重新登录')
          break
        case 404:
          alert('请求的资源不存在')
          break
        case 500:
          alert('服务器内部错误')
          break
        default:
          alert(`请求失败: ${error.response.status}`)
      }
    } else if (error.request) {
      alert('网络错误，请检查后端服务是否启动')
    } else {
      alert('请求配置错误')
    }
    return Promise.reject(error)
  }
)

// 商品API
export const productApi = {
  // 获取所有商品
  getAllProducts() {
    return apiClient.get('/products')
  },

  // 获取单个商品
  getProductById(id) {
    return apiClient.get(`/products/${id}`)
  },

  // 创建商品
  createProduct(productData) {
    return apiClient.post('/products', productData)
  },

  // 更新商品
  updateProduct(id, productData) {
    return apiClient.put(`/products/${id}`, productData)
  },

  // 删除商品
  deleteProduct(id) {
    return apiClient.delete(`/products/${id}`)
  }
}

export default apiClient