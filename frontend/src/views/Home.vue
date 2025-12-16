<template>
  <div class="home">
    <h1>电商数据管理系统</h1>
    <p>欢迎使用电商数据管理系统</p>
    <router-link to="/products">
      <el-button type="primary">管理商品</el-button>
    </router-link>
  </div>
</template>

<script>
export default {
  name: 'Home'
}
</script>

<style scoped>
.home {
  text-align: center;
  padding: 50px;
}
</style>
