import { createRouter, createWebHistory } from 'vue-router'

// 路由组件懒加载
const ProductListView = () => import('../views/ProductList.vue')
const ProductDetailView = () => import('../views/ProductDetail.vue')
const ProductCreateView = () => import('../views/ProductCreate.vue')

const routes = [
  {
    path: '/',
    name: 'Home',
    redirect: '/products'
  },
  {
    path: '/products',
    name: 'ProductList',
    component: ProductListView
  },
  {
    path: '/products/create',
    name: 'ProductCreate',
    component: ProductCreateView
  },
  {
    path: '/products/:id',
    name: 'ProductDetail',
    component: ProductDetailView,
    props: true
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router