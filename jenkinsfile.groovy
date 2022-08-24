pipeline {
    agent any

    environment {
        GIT_URL = "https://github.com/andes-noh/CI-CD-TEST.git"
        dockerHubRegistry = 'andesnoh/sample'
        dockerHubRegistryCredential = 'dockerhub'
        dockerImage = ''
    }

    tools {
        nodejs "NodeJS"
    }

    stages {
        stage('Pull') {
            steps {
                git url: "${GIT_URL}", branch: "main", poll: true, changelog: true
            }
        }

        stage('Build') {
            steps {
              scripts {
                dockerImage = docker.build("${dockerHubRegistry}")
              }
            }
        }

        stage('Push') {
            steps {
              scripts {
                docker.withRegistry('https://registry.hub.docker.com', 'dockerhub')
                dockerImage.push('latest')
              }
            }
        }

       stage('Finish') {
            steps{
                sh "echo 'The end'"
            }
        }
    }
}
