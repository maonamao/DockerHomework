module.exports = {
  publicPath: '/',
  outputDir: 'dist',
  devServer: {
    proxy: {
      '/api': {
        target: 'http://backend:8080',
        changeOrigin: true
      }
    }
  }
}
