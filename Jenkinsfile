pipeline {
    agent any

    environment {
        GIT_URL = "https://github.com/andes-noh/CI-CD-TEST.git"
        dockerHubRegistry = 'andesnoh/sample'
        dockerHubRegistryCredential = credential('dockerhub')
    }

    tools {
        nodejs "NODE_JS"
    }

    stages {
        stage('Pull') {
            steps {
                git url: "${GIT_URL}", branch: "main", poll: true, changelog: true
            }
        }

        stage('Build') {
            steps {
                sh "docker build -t ${dockerHubRegistry}:latest ."
            }
        }

        stage('login'){
            steps {
              sh 'echo $dockerHubRegistryCredential_PSW | docker login -u $dockerHubRegistryCredential_USR --password-stdin'
            }
        }

        stage('Push') {
            steps {
              script {
                docker.withRegistry('https://registry.hub.docker.com', 'dockerhub')
                  sh "docker push ${dockerHubRegistry}:latest"

                  sleep 10
              }
            }
        }

        // stage('Kubernetes Deploy') {
        //     steps{
        //       script{
        //         kubernetesDeploy(configs: "jenkins_deploy.yaml", kubeconfigId: "KubeConfig")
        //       }
        //     }
        // }

       stage('Finish') {
            steps{
                sh "echo 'The end'"
            }
        }
    }

    post {
		  always {
			  sh 'docker logout'
		  }
	  }
}
