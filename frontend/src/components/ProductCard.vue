<template>
  <div class="product-card">
    <div class="product-image">
      <img v-if="product.imageUrl" :src="product.imageUrl" :alt="product.name" />
      <div v-else class="image-placeholder">No Image</div>
    </div>
    <div class="product-info">
      <h3 class="product-name">{{ product.name }}</h3>
      <p class="product-price">¥{{ product.price }}</p>
      <p class="product-stock" :class="{ 'low-stock': product.stock < 10 }">
        库存: {{ product.stock || 0 }}
      </p>
      <p class="product-category">{{ product.category }}</p>
      <div class="product-actions">
        <button @click="viewDetail" class="btn btn-view">查看详情</button>
        <button @click="deleteProduct" class="btn btn-delete">删除</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProductCard',
  props: {
    product: {
      type: Object,
      required: true
    }
  },
  methods: {
    viewDetail() {
      this.$router.push({ name: 'ProductDetail', params: { id: this.product.id } })
    },
    deleteProduct() {
      if (confirm('确定要删除这个商品吗？')) {
        this.$emit('delete', this.product.id)
      }
    }
  }
}
</script>

<style scoped>
.product-card {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 16px;
  margin: 16px;
  width: 300px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.product-image {
  width: 100%;
  height: 200px;
  background-color: #f5f5f5;
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: 12px;
}

.product-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.image-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #666;
}

.product-name {
  margin: 0 0 8px 0;
  font-size: 18px;
  color: #333;
}

.product-price {
  font-size: 20px;
  font-weight: bold;
  color: #e53935;
  margin: 0 0 8px 0;
}

.product-stock {
  margin: 0 0 8px 0;
  color: #666;
}

.low-stock {
  color: #ff9800;
}

.product-category {
  margin: 0 0 12px 0;
  color: #777;
  font-size: 14px;
}

.product-actions {
  display: flex;
  gap: 8px;
}

.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.btn-view {
  background-color: #2196f3;
  color: white;
  flex: 1;
}

.btn-delete {
  background-color: #f44336;
  color: white;
  flex: 1;
}

.btn:hover {
  opacity: 0.9;
}
</style>