
pipeline {
    agent any

    environment {
      VERSION = "1.0.${env.BUILD_NUMBER}"

        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "eu-west-3"

        DOCKER_USERNAME = "underdogdevops"
        DOCKER_REGISTRY = 'https://registry.hub.docker.com'
        DOCKER_CREDENTIALS = credentials('DOCKERHUB_CREDENTIALS')

        ESHOPWEBMVC_IMAGE = "underdogdevops/eshopwebmvc"
        ESHOPPUBLICAPI_IMAGE = "underdogdevops/eshoppublicapi"
        
    }

    stages {
        stage('clean workspace'){
          steps{
              cleanWs()
          }
        }
        stage('Checkout code') {
          steps {
            git(url: 'https://github.com/aleksandrakojic/eShopOnWeb.git', branch: 'main')
            script {
              sh 'ls -la'
            }
            
          }
        }

        stage('Build and Push Docker Images') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'DOCKER_CREDENTIALS', toolName: 'docker') {
                        def eshopwebmvcImage = docker.build("${ESHOPWEBMVC_IMAGE}", './src/Web')
                        eshopwebmvcImage.push()

                        def eshoppublicapiImage = docker.build("${ESHOPPUBLICAPI_IMAGE}", './src/PublicApi')
                        eshoppublicapiImage.push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    dir('kube') {
                        sh 'kustomize edit set image eshopwebmvc=${ESHOPWEBMVC_IMAGE}'
                        sh 'kustomize edit set image eshoppublicapi=${ESHOPPUBLICAPI_IMAGE}'
                        sh 'kustomize build overlays/prod | kubectl apply -f -'
                    }
                }
            }
        }
    }
}
 