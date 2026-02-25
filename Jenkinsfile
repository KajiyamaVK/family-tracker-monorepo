pipeline {
    agent any
    
    triggers {
        githubPush()
    }

    environment {
        DOCKER_IMAGE = 'fam-app'
        DOCKER_CONTAINER_PROD = 'fam-app'
        DOCKER_CONTAINER_DEV = 'fam-app-dev'
    }

    stages {
        stage('Build Application') {
            agent {
                docker {
                    image 'node:lts'
                    args '-u root --network proxy-net' 
                }
            }
            steps {
                sh 'npm install'
                sh 'npm run build -w apps/backend'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                    sh "docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Deploy to Dev') {
            when {
                not { branch 'main' }
            }
            steps {
                script {
                    sh "docker stop ${DOCKER_CONTAINER_DEV} || true"
                    sh "docker rm ${DOCKER_CONTAINER_DEV} || true"
                    sh """
                        docker run -d --name ${DOCKER_CONTAINER_DEV} \\
                            --network proxy-net \\
                            --restart always \\
                            -e NODE_ENV=development \\
                            -e POSTGRES_HOST=\${DEV_POSTGRES_HOST} \\
                            -e POSTGRES_PORT=\${DEV_POSTGRES_PORT} \\
                            -e POSTGRES_USER=\${DEV_POSTGRES_USER} \\
                            -e POSTGRES_PASSWORD=\${DEV_POSTGRES_PASSWORD} \\
                            -e POSTGRES_DB=\${DEV_POSTGRES_DB} \\
                            -e MAIL_HOST=\${DEV_MAIL_HOST} \\
                            -e MAIL_PORT=\${DEV_MAIL_PORT} \\
                            -e MAIL_USER=\${DEV_MAIL_USER} \\
                            -e MAIL_PASS=\${DEV_MAIL_PASS} \\
                            -e JWT_SECRET=\${DEV_JWT_SECRET} \\
                            -e JWT_REFRESH_SECRET=\${DEV_JWT_REFRESH_SECRET} \\
                            -e GOOGLE_CLIENT_ID=\${DEV_GOOGLE_CLIENT_ID} \\
                            ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }

        stage('Deploy to Prod') {
            when {
                branch 'main'
            }
            steps {
                script {
                    sh "docker stop ${DOCKER_CONTAINER_PROD} || true"
                    sh "docker rm ${DOCKER_CONTAINER_PROD} || true"
                    sh """
                        docker run -d --name ${DOCKER_CONTAINER_PROD} \\
                            --network proxy-net \\
                            --restart always \\
                            -e NODE_ENV=production \\
                            -e POSTGRES_HOST=\${PROD_POSTGRES_HOST} \\
                            -e POSTGRES_PORT=\${PROD_POSTGRES_PORT} \\
                            -e POSTGRES_USER=\${PROD_POSTGRES_USER} \\
                            -e POSTGRES_PASSWORD=\${PROD_POSTGRES_PASSWORD} \\
                            -e POSTGRES_DB=\${PROD_POSTGRES_DB} \\
                            -e MAIL_HOST=\${PROD_MAIL_HOST} \\
                            -e MAIL_PORT=\${PROD_MAIL_PORT} \\
                            -e MAIL_USER=\${PROD_MAIL_USER} \\
                            -e MAIL_PASS=\${PROD_MAIL_PASS} \\
                            -e JWT_SECRET=\${PROD_JWT_SECRET} \\
                            -e JWT_REFRESH_SECRET=\${PROD_JWT_REFRESH_SECRET} \\
                            -e GOOGLE_CLIENT_ID=\${PROD_GOOGLE_CLIENT_ID} \\
                            ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
    }
}