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