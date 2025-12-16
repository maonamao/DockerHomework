<template>
  <div>
    <h2>商品详情</h2>
    <div v-if="product">
      <el-descriptions :column="1" border>
        <el-descriptions-item label="商品ID">{{ product.id }}</el-descriptions-item>
        <el-descriptions-item label="商品名称">{{ product.name }}</el-descriptions-item>
        <el-descriptions-item label="价格">¥{{ product.price }}</el-descriptions-item>
        <el-descriptions-item label="库存">{{ product.stock }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ product.createdAt }}</el-descriptions-item>
      </el-descriptions>
      <el-button @click="$router.back()" style="margin-top: 20px">返回</el-button>
    </div>
    <div v-else>
      商品不存在
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProductDetail',
  props: ['id'],
  data() {
    return {
      product: null
    }
  },
  created() {
    this.loadProduct()
  },
  methods: {
    async loadProduct() {
      try {
        const response = await this.$axios.get(`/products/${this.id}`)
        this.product = response
      } catch (error) {
        this.$message.error('加载失败')
      }
    }
  }
}
</script>
