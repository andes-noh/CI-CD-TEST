pipeline {
    agent any

    environment {
        GIT_URL = "https://github.com/andes-noh/CI-CD-TEST.git"
        dockerHubRegistry = 'andesnoh/cicd_test'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-jenkins')
        namespace='jenkins'
        selector_key='app.kubernetes.io/name'
        selector_val='test'
        manifest='test.k8s.yaml'
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
                sh "docker build -t ${dockerHubRegistry}:${env.BUILD_NUMBER} ."
            }
        }

        stage('login'){
            steps {
              sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Push') {
            steps {
              script {
                  sh "docker push ${dockerHubRegistry}:${env.BUILD_NUMBER}"
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

        stage('Clean') {
            steps {
                sh "echo 'The end'"
                sh "docker rmi ${dockerHubRegistry}:${BUILD_ID}"
                sh "docker logout"
            }
        }

        stage( "Clean Up Existing Deployments" ) {
          steps {
            script {
    					sh "kubectl delete deployments -n ${namespace} --selector=${selector_key}=${selector_val}"
            }
          }
				}

			  stage( "Deploy to Cluster" ) {
            steps {
              script {
                sh '''sed 's/IMAGE_VERSION/${env.BUILD_NUMBER}/g' ${manifest}>output.yaml'''
                sh "kubectl apply -n ${namespace} -f ${output.yaml}"
					      sh "sleep 5"
					      sh "kubectl apply -n ${namespace} -f ${service}"
                sh "rm -rf output.yaml"
            }
          }
				}
        // stage('Deploy to kubernetes'){
        //   steps {
        //     script {
        //       kubernetesDeploy (configs: 'test.k8s.yaml', kubeconfigId: 'kubeconfig')
        //       sh "/usr/local/bin/kubectl --kubeconfig=/home/test.yaml rollout restart deployment/test-deployment -n zuno"
        //     }
        //   }

        // steps {
        //   script{
        //     kubernetesDeploy(configs: "test.yaml", kubeconfigId: "kubeconfig")
        //   }
        // }

        // docker run
        // stage('Docker Run'){
        //     steps {
        //         sh "docker run -d -p 3000:3000 --rm --name MySampleApp ${dockerHubRegistry}:latest"
        //     }
        // }
    }
}
