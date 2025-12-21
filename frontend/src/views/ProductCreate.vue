<template>
  <div class="product-form">
    <div class="header">
      <button @click="goBack" class="btn-back">← 返回</button>
      <h1>{{ isEditMode ? '编辑商品' : '创建商品' }}</h1>
    </div>

    <form @submit.prevent="handleSubmit" class="form">
      <div class="form-group">
        <label for="name">商品名称 *</label>
        <input
          id="name"
          v-model="formData.name"
          type="text"
          required
          placeholder="请输入商品名称"
        />
      </div>

      <div class="form-group">
        <label for="price">价格 *</label>
        <input
          id="price"
          v-model="formData.price"
          type="number"
          step="0.01"
          min="0"
          required
          placeholder="请输入价格"
        />
      </div>

      <div class="form-group">
        <label for="stock">库存</label>
        <input
          id="stock"
          v-model="formData.stock"
          type="number"
          min="0"
          placeholder="请输入库存数量"
        />
      </div>

      <div class="form-group">
        <label for="category">分类</label>
        <input
          id="category"
          v-model="formData.category"
          type="text"
          placeholder="请输入商品分类"
        />
      </div>

      <div class="form-group">
        <label for="imageUrl">图片URL</label>
        <input
          id="imageUrl"
          v-model="formData.imageUrl"
          type="text"
          placeholder="请输入图片链接"
        />
      </div>

      <div class="form-group">
        <label for="description">商品描述</label>
        <textarea
          id="description"
          v-model="formData.description"
          rows="4"
          placeholder="请输入商品描述"
        ></textarea>
      </div>

      <div class="form-actions">
        <button type="button" @click="goBack" class="btn-cancel">取消</button>
        <button type="submit" :disabled="submitting" class="btn-submit">
          {{ submitting ? '提交中...' : (isEditMode ? '更新商品' : '创建商品') }}
        </button>
      </div>
    </form>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { productApi } from '@/api'

export default {
  name: 'ProductCreate',
  setup() {
    const route = useRoute()
    const router = useRouter()
    const isEditMode = ref(false)
    const submitting = ref(false)

    const formData = ref({
      name: '',
      price: '',
      stock: '',
      category: '',
      imageUrl: '',
      description: ''
    })

    const productId = route.query.id

    onMounted(async () => {
      if (productId) {
        isEditMode.value = true
        try {
          const response = await productApi.getProductById(productId)
          if (response.data.success) {
            const product = response.data.data
            formData.value = {
              name: product.name || '',
              price: product.price || '',
              stock: product.stock || '',
              category: product.category || '',
              imageUrl: product.imageUrl || '',
              description: product.description || ''
            }
          }
        } catch (error) {
          console.error('获取商品信息失败:', error)
          alert('获取商品信息失败')
        }
      }
    })

    const handleSubmit = async () => {
      if (submitting.value) return

      // 验证必填字段
      if (!formData.value.name.trim() || !formData.value.price) {
        alert('请填写商品名称和价格')
        return
      }

      submitting.value = true

      try {
        const data = {
          ...formData.value,
          price: parseFloat(formData.value.price),
          stock: formData.value.stock ? parseInt(formData.value.stock) : 0
        }

        if (isEditMode.value) {
          await productApi.updateProduct(productId, data)
          alert('商品更新成功')
        } else {
          await productApi.createProduct(data)
          alert('商品创建成功')
        }

        router.push({ name: 'ProductList' })
      } catch (error) {
        console.error('提交失败:', error)
        alert(isEditMode.value ? '更新失败' : '创建失败')
      } finally {
        submitting.value = false
      }
    }

    const goBack = () => {
      router.push({ name: 'ProductList' })
    }

    return {
      isEditMode,
      formData,
      submitting,
      handleSubmit,
      goBack
    }
  }
}
</script>

<style scoped>
.product-form {
  padding: 20px;
  max-width: 600px;
  margin: 0 auto;
}

.header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 32px;
}

.header h1 {
  margin: 0;
  color: #333;
}

.btn-back {
  background: none;
  border: none;
  color: #2196f3;
  cursor: pointer;
  font-size: 16px;
  padding: 0;
}

.btn-back:hover {
  text-decoration: underline;
}

.form {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 32px;
}

.form-group {
  margin-bottom: 24px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  color: #555;
  font-weight: 500;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 16px;
  box-sizing: border-box;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #2196f3;
  box-shadow: 0 0 0 2px rgba(33, 150, 243, 0.1);
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 16px;
  padding-top: 24px;
  border-top: 1px solid #eee;
}

.btn-cancel,
.btn-submit {
  padding: 12px 32px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
  min-width: 120px;
}

.btn-cancel {
  background-color: #f5f5f5;
  color: #333;
}

.btn-cancel:hover {
  background-color: #e0e0e0;
}

.btn-submit {
  background-color: #4caf50;
  color: white;
}

.btn-submit:hover:not(:disabled) {
  background-color: #45a049;
}

.btn-submit:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}
</style>