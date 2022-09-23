def label = "test-${UUID.randomUUID().toString()}"


podTemplate(
	label: label,
	containers: [
		//container image는 docker search 명령 이용
		containerTemplate(name: "docker", image: "docker:latest", ttyEnabled: true, command: "cat"),
		containerTemplate(name: "kubectl", image: "lachlanevenson/k8s-kubectl", command: "cat", ttyEnabled: true)
	],
	//volume mount
	volumes: [
		hostPathVolume(hostPath: "/var/run/docker.sock", mountPath: "/var/run/docker.sock")
	]
)
{
	node(label) {
		stage("Get Source") {
			//git url:"https://github.com/happykube/hellonode.git", branch: "main", credentialsId: "git_credential"
		    git branch: 'main', url: 'https://github.com/andes-noh/CI-CD-TEST.git'
        }

		// // -- 환경변수 파일 읽어서 변수값 셋팅
		// def props = readProperties  file:"deployment/pipeline.properties"
		// def tag = props["version"]
		// def dockerRegistry = props["dockerRegistry"]
		// def credential_registry=props["credential_registry"]
		// def image = props["image"]
		// def deployment = props["deployment"]
		// def service = props["service"]
		// def ingress = props["ingress"]
		// def selector_key = props["selector_key"]
		// def selector_val = props["selector_val"]
		// def namespace = props["namespace"]

    def GIT_URL = "https://github.com/andes-noh/CI-CD-TEST.git"
    def dockerHubRegistry = 'andesnoh/sample'
    def DOCKERHUB_CREDENTIALS = credentials('dockerhub-jenkins')
    def namespace='jenkins'
    def selector_key='app.kubernetes.io/name'
    def selector_val='test'
    def deployment='test.deployment.yaml'
    def service='test.service.yaml'

		try {
      stage('Build') {
          steps {
              sh "docker build -t ${dockerHubRegistry}:latest ."
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
                sh "docker push ${dockerHubRegistry}:latest"
                sleep 10
            }
          }
      }

			stage( "Clean Up Existing Deployments" ) {
				container("kubectl") {
					sh "kubectl delete deployments -n ${namespace} --selector=${selector_key}=${selector_val}"
				}
			}

			stage( "Deploy to Cluster" ) {
				container("kubectl") {
					sh "kubectl apply -n ${namespace} -f ${deployment}"
					sh "sleep 5"
					sh "kubectl apply -n ${namespace} -f ${service}"
				}
			}

		} catch(e) {
			currentBuild.result = "FAILED"
		}
	}
}
