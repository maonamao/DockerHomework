<template>
  <div class="product-detail">
    <button @click="goBack" class="btn-back">← 返回列表</button>

    <div v-if="loading" class="loading">加载中...</div>

    <div v-else-if="product" class="detail-content">
      <div class="product-header">
        <h1>{{ product.name }}</h1>
        <div class="product-meta">
          <span class="price">¥{{ product.price }}</span>
          <span class="stock" :class="{ 'low-stock': product.stock < 10 }">
            库存: {{ product.stock || 0 }}
          </span>
        </div>
      </div>

      <div class="product-body">
        <div class="image-section">
          <div v-if="product.imageUrl" class="product-image">
            <img :src="product.imageUrl" :alt="product.name" />
          </div>
          <div v-else class="no-image">暂无图片</div>
        </div>

        <div class="info-section">
          <div class="info-item">
            <h3>商品描述</h3>
            <p>{{ product.description || '暂无描述' }}</p>
          </div>

          <div class="info-item">
            <h3>商品分类</h3>
            <p>{{ product.category || '未分类' }}</p>
          </div>

          <div class="info-item">
            <h3>创建时间</h3>
            <p>{{ formatDate(product.createdAt) }}</p>
          </div>

          <div class="info-item">
            <h3>更新时间</h3>
            <p>{{ formatDate(product.updatedAt) }}</p>
          </div>
        </div>
      </div>

      <div class="action-buttons">
        <button @click="editProduct" class="btn-edit">编辑商品</button>
        <button @click="deleteProduct" class="btn-delete">删除商品</button>
      </div>
    </div>

    <div v-else class="not-found">
      <h2>商品不存在</h2>
      <button @click="goBack" class="btn-back">返回列表</button>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { productApi } from '@/api'

export default {
  name: 'ProductDetail',
  props: ['id'],
  setup(props) {
    const route = useRoute()
    const router = useRouter()
    const product = ref(null)
    const loading = ref(true)

    const productId = props.id || route.params.id

    const fetchProduct = async () => {
      try {
        loading.value = true
        const response = await productApi.getProductById(productId)
        if (response.data.success) {
          product.value = response.data.data
        } else {
          product.value = null
        }
      } catch (error) {
        console.error('获取商品详情失败:', error)
        product.value = null
      } finally {
        loading.value = false
      }
    }

    const formatDate = (dateString) => {
      if (!dateString) return '未知'
      const date = new Date(dateString)
      // 更健壮的日期格式化
      return date.toLocaleDateString('zh-CN') + ' ' + date.toLocaleTimeString('zh-CN')
    }

    const goBack = () => {
      router.push({ name: 'ProductList' })
    }

    const editProduct = () => {
      router.push({ name: 'ProductCreate', query: { id: productId } })
    }

    const deleteProduct = async () => {
      if (confirm('确定要删除这个商品吗？')) {
        try {
          await productApi.deleteProduct(productId)
          alert('删除成功')
          goBack()
        } catch (error) {
          console.error('删除失败:', error)
          alert('删除失败')
        }
      }
    }

    onMounted(() => {
      fetchProduct()
    })

    return {
      product,
      loading,
      formatDate,
      goBack,
      editProduct,
      deleteProduct
    }
  }
}
</script>

<style scoped>
.product-detail {
  padding: 20px;
  max-width: 1000px;
  margin: 0 auto;
}

.btn-back {
  background: none;
  border: none;
  color: #2196f3;
  cursor: pointer;
  font-size: 16px;
  margin-bottom: 20px;
  padding: 0;
}

.btn-back:hover {
  text-decoration: underline;
}

.loading {
  text-align: center;
  padding: 40px;
  font-size: 18px;
  color: #666;
}

.detail-content {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 24px;
}

.product-header {
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid #eee;
}

.product-header h1 {
  margin: 0 0 12px 0;
  color: #333;
}

.product-meta {
  display: flex;
  gap: 24px;
  align-items: center;
}

.price {
  font-size: 28px;
  font-weight: bold;
  color: #e53935;
}

.stock {
  font-size: 18px;
  color: #666;
}

.low-stock {
  color: #ff9800;
}

.product-body {
  display: grid;
  grid-template-columns: 300px 1fr;
  gap: 32px;
  margin-bottom: 32px;
}

.image-section {
  background-color: #f5f5f5;
  border-radius: 8px;
  overflow: hidden;
  height: 300px;
}

.product-image {
  width: 100%;
  height: 100%;
}

.product-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.no-image {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #666;
  font-size: 18px;
}

.info-section {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.info-item h3 {
  margin: 0 0 8px 0;
  color: #555;
  font-size: 18px;
}

.info-item p {
  margin: 0;
  color: #666;
  line-height: 1.6;
}

.action-buttons {
  display: flex;
  gap: 16px;
  justify-content: center;
  padding-top: 24px;
  border-top: 1px solid #eee;
}

.btn-edit, .btn-delete {
  padding: 12px 32px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
  min-width: 120px;
}

.btn-edit {
  background-color: #2196f3;
  color: white;
}

.btn-delete {
  background-color: #f44336;
  color: white;
}

.btn-edit:hover, .btn-delete:hover {
  opacity: 0.9;
}

.not-found {
  text-align: center;
  padding: 60px 20px;
}

.not-found h2 {
  color: #666;
  margin-bottom: 20px;
}
</style>