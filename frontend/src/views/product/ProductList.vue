<template>
  <div class="product-list-container">
    <div class="header">
      <el-button type="primary" @click="goToCreate" icon="el-icon-plus">
        添加商品
      </el-button>
      <el-input
        v-model="searchQuery"
        placeholder="搜索商品..."
        style="width: 300px; margin-left: 20px"
        @keyup.enter="handleSearch"
      >
        <el-button slot="append" icon="el-icon-search" @click="handleSearch" />
      </el-input>
    </div>

    <div class="table-container">
      <el-table
        :data="filteredProducts"
        v-loading="loading"
        border
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="商品名称" />
        <el-table-column prop="category" label="分类" width="120" />
        <el-table-column prop="price" label="价格" width="120">
          <template slot-scope="scope">
            ¥{{ scope.row.price.toFixed(2) }}
          </template>
        </el-table-column>
        <el-table-column prop="stock" label="库存" width="100" />
        <el-table-column label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="scope.row.stock > 0 ? 'success' : 'danger'">
              {{ scope.row.stock > 0 ? '有货' : '缺货' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template slot-scope="scope">
            <el-button
              size="mini"
              @click="handleView(scope.row.id)"
              icon="el-icon-view"
            >
              查看
            </el-button>
            <el-button
              size="mini"
              type="primary"
              @click="handleEdit(scope.row.id)"
              icon="el-icon-edit"
            >
              编辑
            </el-button>
            <el-button
              size="mini"
              type="danger"
              @click="handleDelete(scope.row.id)"
              icon="el-icon-delete"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
        :page-sizes="[10, 20, 50, 100]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="products.length"
        style="margin-top: 20px; text-align: right;"
      />
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProductList',
  data() {
    return {
      searchQuery: '',
      currentPage: 1,
      pageSize: 10,
      loading: false
    }
  },
  computed: {
    products() {
      return this.$store.getters.allProducts
    },
    filteredProducts() {
      let filtered = this.products
      if (this.searchQuery) {
        filtered = filtered.filter(product => 
          product.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
          product.category.toLowerCase().includes(this.searchQuery.toLowerCase())
        )
      }
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return filtered.slice(start, end)
    }
  },
  created() {
    this.loadProducts()
  },
  methods: {
    async loadProducts() {
      try {
        this.loading = true
        await this.$store.dispatch('fetchProducts')
      } catch (error) {
        this.$message.error('加载商品失败')
      } finally {
        this.loading = false
      }
    },
    goToCreate() {
      this.$router.push('/products/create')
    },
    handleView(id) {
      this.$router.push(`/products/${id}`)
    },
    handleEdit(id) {
      this.$router.push(`/products/edit/${id}`)
    },
    async handleDelete(id) {
      try {
        await this.$confirm('确定删除该商品吗？', '提示', {
          type: 'warning',
          confirmButtonText: '确定',
          cancelButtonText: '取消'
        })
        
        await this.$store.dispatch('deleteProduct', id)
        this.$message.success('删除成功')
      } catch (error) {
        if (error !== 'cancel') {
          this.$message.error('删除失败')
        }
      }
    },
    handleSearch() {
      this.currentPage = 1
    },
    handleSizeChange(size) {
      this.pageSize = size
    },
    handleCurrentChange(page) {
      this.currentPage = page
    }
  }
}
</script>

<style scoped>
.product-list-container {
  padding: 20px;
}

.header {
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.table-container {
  background: white;
  padding: 20px;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,.1);
}

.el-button + .el-button {
  margin-left: 10px;
}
</style>
