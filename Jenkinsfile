pipeline {
    agent {
        docker {
            image 'node:lts'
            args '-v /var/run/docker.sock:/var/run/docker.sock -u root --network proxy-net' 
        }
    }

    environment {
        DOCKER_IMAGE = 'fam-app'
        DOCKER_CONTAINER_PROD = 'fam-app'
        DOCKER_CONTAINER_DEV = 'fam-app-dev'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
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
                    sh "docker run -d --name ${DOCKER_CONTAINER_DEV} --network proxy-net --restart always ${DOCKER_IMAGE}:latest"
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
                    sh "docker run -d --name ${DOCKER_CONTAINER_PROD} --network proxy-net --restart always ${DOCKER_IMAGE}:latest"
                }
            }
        }
    }
}
