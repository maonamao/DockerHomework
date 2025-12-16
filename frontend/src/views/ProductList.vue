<template>
  <div>
    <h2>商品列表</h2>
    <el-button type="primary" @click="addProduct">添加商品</el-button>
    
    <el-table :data="products" style="width: 100%; margin-top: 20px">
      <el-table-column prop="id" label="ID" width="80"></el-table-column>
      <el-table-column prop="name" label="商品名称"></el-table-column>
      <el-table-column prop="price" label="价格" width="120">
        <template slot-scope="scope">
          ¥{{ scope.row.price }}
        </template>
      </el-table-column>
      <el-table-column prop="stock" label="库存" width="100"></el-table-column>
      <el-table-column label="操作" width="200">
        <template slot-scope="scope">
          <el-button size="mini" @click="editProduct(scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="deleteProduct(scope.row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'ProductList',
  data() {
    return {
      products: []
    }
  },
  created() {
    this.loadProducts()
  },
  methods: {
    async loadProducts() {
      try {
        const response = await this.$axios.get('/products')
        this.products = response
      } catch (error) {
        this.$message.error('加载失败')
      }
    },
    addProduct() {
      this.$prompt('请输入商品名称', '添加商品', {
        inputPattern: /\S+/,
        inputErrorMessage: '商品名称不能为空'
      }).then(async ({ value }) => {
        const product = {
          name: value,
          price: 0,
          stock: 0
        }
        try {
          await this.$axios.post('/products', product)
          this.$message.success('添加成功')
          this.loadProducts()
        } catch (error) {
          this.$message.error('添加失败')
        }
      })
    },
    editProduct(product) {
      this.$prompt('请输入新名称', '编辑商品', {
        inputValue: product.name,
        inputPattern: /\S+/,
        inputErrorMessage: '商品名称不能为空'
      }).then(async ({ value }) => {
        const updatedProduct = { ...product, name: value }
        try {
          await this.$axios.put(`/products/${product.id}`, updatedProduct)
          this.$message.success('更新成功')
          this.loadProducts()
        } catch (error) {
          this.$message.error('更新失败')
        }
      })
    },
    async deleteProduct(id) {
      try {
        await this.$confirm('确定删除吗？', '提示', { type: 'warning' })
        await this.$axios.delete(`/products/${id}`)
        this.$message.success('删除成功')
        this.loadProducts()
      } catch (error) {
        // 用户取消删除
      }
    }
  }
}
</script>
