<template>
  <div class="product-list">
    <div class="header">
      <h1>商品管理</h1>
      <button @click="goToCreate" class="btn-create">添加商品</button>
    </div>

    <div v-if="loading" class="loading">加载中...</div>

    <div v-else>
      <div v-if="products.length === 0" class="empty">
        <p>暂无商品数据</p>
        <button @click="goToCreate" class="btn-create">添加第一个商品</button>
      </div>

      <div v-else class="products-grid">
        <ProductCard
          v-for="product in products"
          :key="product.id"
          :product="product"
          @delete="handleDelete"
        />
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { productApi } from '@/api'
import ProductCard from '@/components/ProductCard.vue'

export default {
  name: 'ProductList',
  components: {
    ProductCard
  },
  setup() {
    const router = useRouter()
    const products = ref([])
    const loading = ref(true)

    const fetchProducts = async () => {
      try {
        loading.value = true
        const response = await productApi.getAllProducts()
        if (response.data.success) {
          products.value = response.data.data
        }
      } catch (error) {
        console.error('获取商品列表失败:', error)
        alert('获取商品列表失败，请检查后端服务')
      } finally {
        loading.value = false
      }
    }

    const handleDelete = async (id) => {
      try {
        await productApi.deleteProduct(id)
        products.value = products.value.filter(p => p.id !== id)
        alert('删除成功')
      } catch (error) {
        console.error('删除失败:', error)
        alert('删除失败')
      }
    }

    const goToCreate = () => {
      router.push({ name: 'ProductCreate' })
    }

    onMounted(() => {
      fetchProducts()
    })

    return {
      products,
      loading,
      handleDelete,
      goToCreate
    }
  }
}
</script>

<style scoped>
.product-list {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid #eee;
}

.header h1 {
  margin: 0;
  color: #333;
}

.btn-create {
  padding: 10px 20px;
  background-color: #4caf50;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
}

.btn-create:hover {
  background-color: #45a049;
}

.loading {
  text-align: center;
  padding: 40px;
  font-size: 18px;
  color: #666;
}

.empty {
  text-align: center;
  padding: 60px 20px;
}

.empty p {
  font-size: 18px;
  color: #666;
  margin-bottom: 20px;
}

.products-grid {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 16px;
}
</style>