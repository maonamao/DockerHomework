import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)

const state = {
  token: localStorage.getItem('token') || '',
  user: JSON.parse(localStorage.getItem('user') || 'null'),
  products: [],
  cart: [],
  loading: false,
  error: null
}

const mutations = {
  SET_TOKEN(state, token) {
    state.token = token
    localStorage.setItem('token', token)
    axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
  },
  SET_USER(state, user) {
    state.user = user
    localStorage.setItem('user', JSON.stringify(user))
  },
  SET_PRODUCTS(state, products) {
    state.products = products
  },
  ADD_PRODUCT(state, product) {
    state.products.push(product)
  },
  UPDATE_PRODUCT(state, updatedProduct) {
    const index = state.products.findIndex(p => p.id === updatedProduct.id)
    if (index !== -1) {
      Vue.set(state.products, index, updatedProduct)
    }
  },
  DELETE_PRODUCT(state, productId) {
    state.products = state.products.filter(p => p.id !== productId)
  },
  SET_LOADING(state, loading) {
    state.loading = loading
  },
  SET_ERROR(state, error) {
    state.error = error
  },
  CLEAR_ERROR(state) {
    state.error = null
  },
  ADD_TO_CART(state, product) {
    const existingItem = state.cart.find(item => item.id === product.id)
    if (existingItem) {
      existingItem.quantity += 1
    } else {
      state.cart.push({ ...product, quantity: 1 })
    }
  },
  REMOVE_FROM_CART(state, productId) {
    state.cart = state.cart.filter(item => item.id !== productId)
  },
  CLEAR_CART(state) {
    state.cart = []
  },
  LOGOUT(state) {
    state.token = ''
    state.user = null
    state.products = []
    state.cart = []
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    delete axios.defaults.headers.common['Authorization']
  }
}

const actions = {
  async login({ commit }, credentials) {
    try {
      commit('SET_LOADING', true)
      const response = await axios.post('/api/auth/login', credentials)
      commit('SET_TOKEN', response.data.token)
      commit('SET_USER', response.data.user)
      commit('SET_ERROR', null)
      return response
    } catch (error) {
      commit('SET_ERROR', error.response?.data?.message || '登录失败')
      throw error
    } finally {
      commit('SET_LOADING', false)
    }
  },
  
  async fetchProducts({ commit }) {
    try {
      commit('SET_LOADING', true)
      const response = await axios.get('/api/products')
      commit('SET_PRODUCTS', response.data)
      return response
    } catch (error) {
      commit('SET_ERROR', '获取商品列表失败')
      throw error
    } finally {
      commit('SET_LOADING', false)
    }
  },
  
  async createProduct({ commit }, productData) {
    try {
      commit('SET_LOADING', true)
      const response = await axios.post('/api/products', productData)
      commit('ADD_PRODUCT', response.data)
      return response
    } catch (error) {
      commit('SET_ERROR', '创建商品失败')
      throw error
    } finally {
      commit('SET_LOADING', false)
    }
  },
  
  async updateProduct({ commit }, { id, productData }) {
    try {
      commit('SET_LOADING', true)
      const response = await axios.put(`/api/products/${id}`, productData)
      commit('UPDATE_PRODUCT', response.data)
      return response
    } catch (error) {
      commit('SET_ERROR', '更新商品失败')
      throw error
    } finally {
      commit('SET_LOADING', false)
    }
  },
  
  async deleteProduct({ commit }, id) {
    try {
      commit('SET_LOADING', true)
      await axios.delete(`/api/products/${id}`)
      commit('DELETE_PRODUCT', id)
    } catch (error) {
      commit('SET_ERROR', '删除商品失败')
      throw error
    } finally {
      commit('SET_LOADING', false)
    }
  },
  
  logout({ commit }) {
    commit('LOGOUT')
  }
}

const getters = {
  isAuthenticated: state => !!state.token,
  currentUser: state => state.user,
  allProducts: state => state.products,
  productById: state => id => state.products.find(p => p.id === id),
  cartItems: state => state.cart,
  cartTotal: state => state.cart.reduce((total, item) => total + (item.price * item.quantity), 0),
  isLoading: state => state.loading,
  error: state => state.error
}

export default new Vuex.Store({
  state,
  mutations,
  actions,
  getters,
  strict: process.env.NODE_ENV !== 'production'
})
