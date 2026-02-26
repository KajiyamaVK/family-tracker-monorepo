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
                            -e POSTGRES_HOST=postgres-postgis \\
                            -e POSTGRES_PORT=\${POSTGRES_PORT} \\
                            -e POSTGRES_USER=\${POSTGRES_USER} \\
                            -e POSTGRES_PASSWORD=\${POSTGRES_PASSWORD} \\
                            -e POSTGRES_DB=\${DEV_POSTGRES_DB} \\
                            -e MAIL_HOST=\${MAIL_HOST} \\
                            -e MAIL_PORT=587 \\
                            -e MAIL_USER=\${MAIL_USER} \\
                            -e MAIL_PASS=\${MAIL_PASS} \\
                            -e JWT_SECRET=\${JWT_SECRET} \\
                            -e JWT_REFRESH_SECRET=\${JWT_REFRESH_SECRET} \\
                            -e GOOGLE_CLIENT_ID=\${GOOGLE_CLIENT_ID} \\
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
                            -e POSTGRES_HOST=postgres-postgis \\
                            -e POSTGRES_PORT=\${POSTGRES_PORT} \\
                            -e POSTGRES_USER=\${POSTGRES_USER} \\
                            -e POSTGRES_PASSWORD=\${POSTGRES_PASSWORD} \\
                            -e POSTGRES_DB=\${PROD_POSTGRES_DB} \\
                            -e MAIL_HOST=\${MAIL_HOST} \\
                            -e MAIL_PORT=587 \\
                            -e MAIL_USER=\${MAIL_USER} \\
                            -e MAIL_PASS=\${MAIL_PASS} \\
                            -e JWT_SECRET=\${JWT_SECRET} \\
                            -e JWT_REFRESH_SECRET=\${JWT_REFRESH_SECRET} \\
                            -e GOOGLE_CLIENT_ID=\${GOOGLE_CLIENT_ID} \\
                            ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
    }
}