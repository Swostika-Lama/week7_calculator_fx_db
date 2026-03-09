pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:$PATH"
        DOCKERHUB_CREDENTIALS_ID = 'docker-jenkins'
        DOCKERHUB_REPO = 'swostikalama/week7'
        DOCKER_IMAGE_TAG = 'latest'
    }

    tools {
        maven 'MAVEN_HOME'
    }

    stages {

        stage('Check Docker') {
            steps {
                sh 'docker --version'
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 'https://github.com/Swostika-Lama/week7_calculator_fx_db.git'
            }
        }

        stage('Build Job:') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Build Docker Image') {
                    steps {
                        sh 'docker build -t ${DOCKERHUB_REPO}:${DOCKER_IMAGE_TAG} .'
                    }
                }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "${DOCKERHUB_CREDENTIALS_ID}",
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKERHUB_REPO}:${DOCKER_IMAGE_TAG}
                    '''
                }
            }
        }
    }
}