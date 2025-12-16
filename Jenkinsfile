pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'registry.example.com'
        PROJECT_NAME = 'ecommerce-system'
        VERSION = "${env.BUILD_NUMBER}"
    }
    
    stages {
        // 阶段1: 代码检出
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/your-repo/ecommerce-system.git',
                    credentialsId: 'github-credentials'
            }
        }
        
        // 阶段2: 代码质量检查
        stage('Code Quality') {
            steps {
                script {
                    // 前端代码检查
                    dir('frontend') {
                        sh 'npm ci'
                        sh 'npm run lint || true'
                    }
                    
                    // 后端代码检查
                    dir('backend') {
                        sh 'mvn checkstyle:check'
                    }
                }
            }
        }
        
        // 阶段3: 单元测试
        stage('Unit Tests') {
            steps {
                script {
                    dir('backend') {
                        sh 'mvn test'
                    }
                }
            }
            post {
                always {
                    junit 'backend/target/surefire-reports/*.xml'
                }
            }
        }
        
        // 阶段4: 构建镜像
        stage('Build Docker Images') {
            steps {
                script {
                    // 构建后端镜像
                    dir('backend') {
                        sh "docker build -t ${DOCKER_REGISTRY}/${PROJECT_NAME}-backend:${VERSION} ."
                        sh "docker build -t ${DOCKER_REGISTRY}/${PROJECT_NAME}-backend:latest ."
                    }
                    
                    // 构建前端镜像
                    dir('frontend') {
                        sh "docker build -t ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:${VERSION} ."
                        sh "docker build -t ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:latest ."
                    }
                }
            }
        }
        
        // 阶段5: 集成测试
        stage('Integration Tests') {
            steps {
                script {
                    // 启动测试环境
                    sh 'docker-compose -f docker-compose.test.yml up -d'
                    
                    // 等待服务启动
                    sh 'sleep 60'
                    
                    // 运行集成测试
                    dir('backend') {
                        sh 'mvn verify -Dit.test=*IntegrationTest'
                    }
                    
                    // 停止测试环境
                    sh 'docker-compose -f docker-compose.test.yml down'
                }
            }
            post {
                always {
                    junit 'backend/target/failsafe-reports/*.xml'
                }
            }
        }
        
        // 阶段6: 推送镜像
        stage('Push Images') {
            steps {
                script {
                    // 登录Docker Registry
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-registry-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        sh "echo ${DOCKER_PASSWORD} | docker login ${DOCKER_REGISTRY} -u ${DOCKER_USER} --password-stdin"
                    }
                    
                    // 推送镜像
                    sh "docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}-backend:${VERSION}"
                    sh "docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}-backend:latest"
                    sh "docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:${VERSION}"
                    sh "docker push ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:latest"
                }
            }
        }
        
        // 阶段7: 部署到测试环境
        stage('Deploy to Staging') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    sshagent(['staging-server-credentials']) {
                        sh """
                            ssh user@staging-server "
                                cd /opt/ecommerce-system &&
                                docker pull ${DOCKER_REGISTRY}/${PROJECT_NAME}-backend:latest &&
                                docker pull ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:latest &&
                                docker-compose down &&
                                docker-compose up -d
                            "
                        """
                    }
                }
            }
        }
        
        // 阶段8: 部署到生产环境
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                input message: '确认部署到生产环境?', ok: '确认'
                script {
                    sshagent(['production-server-credentials']) {
                        sh """
                            ssh user@production-server "
                                cd /opt/ecommerce-system &&
                                docker pull ${DOCKER_REGISTRY}/${PROJECT_NAME}-backend:${VERSION} &&
                                docker pull ${DOCKER_REGISTRY}/${PROJECT_NAME}-frontend:${VERSION} &&
                                docker-compose down &&
                                docker-compose up -d
                            "
                        """
                    }
                }
            }
        }
    }
    
    post {
        success {
            slackSend(
                channel: '#build-notifications',
                message: "构建成功: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
            )
        }
        failure {
            slackSend(
                channel: '#build-notifications',
                message: "构建失败: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
            )
        }
        always {
            cleanWs()
        }
    }
}
