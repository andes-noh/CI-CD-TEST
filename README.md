# CI/CD test Project

- yarn upgrade ts-node-dev@latest ts-node@latest 버전 업그레이드
- nestjs standalone application

## kubernetes

- k3s

## github actions

- /.github/workflows/workflow.yml

## docker hub

- andesnoh/cicd_test

## argoCD

- (test-kustomize)[https://github.com/andes-noh/test-kustomize]

## jenkins 관련

- Jenkinsfile
- test.deployment.yaml
- test.service.yaml

## jenkins flow

- github webhook 인식
- main branch source code pull
- docker build(Dockerfile)
- docker hub login
- docker push
- local container delete & docker hub logout
- existing deployment delete
- deployment & service deploy

## jenkins setting

- docker hub 로그인용 credential
- webhook 세팅
- docker hub registry address

## References

- [kubectl k3s permissions](https://github.com/k3s-io/k3s/issues/389)
