<template>
  <div id="app">
    <nav class="navbar">
      <h1>电商数据管理系统</h1>
    </nav>
    <div class="container">
      <div class="sidebar">
        <ul>
          <li @click="currentView = 'products'">商品管理</li>
          <li @click="currentView = 'orders'">订单管理</li>
          <li @click="currentView = 'analytics'">数据分析</li>
        </ul>
      </div>
      <div class="main-content">
        <div v-if="currentView === 'products'">
          <h2>商品列表</h2>
          <div class="product-list">
            <div v-for="product in products" :key="product.id" class="product-card">
              <img :src="product.image" alt="商品图片">
              <h3>{{ product.name }}</h3>
              <p>{{ product.description }}</p>
              <span class="price">¥{{ product.price }}</span>
              <button @click="editProduct(product)">编辑</button>
              <button @click="deleteProduct(product.id)">删除</button>
            </div>
          </div>
          <button @click="showAddForm = true">添加商品</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      currentView: 'products',
      products: [],
      showAddForm: false
    }
  },
  mounted() {
    this.fetchProducts();
  },
  methods: {
    async fetchProducts() {
      try {
        const response = await fetch(`${process.env.VUE_APP_API_URL}/products`);
        this.products = await response.json();
      } catch (error) {
        console.error('获取商品失败:', error);
      }
    },
    async deleteProduct(id) {
      if (confirm('确认删除?')) {
        await fetch(`${process.env.VUE_APP_API_URL}/products/${id}`, {
          method: 'DELETE'
        });
        this.fetchProducts();
      }
    }
  }
}
</script>

<style>
</style>
