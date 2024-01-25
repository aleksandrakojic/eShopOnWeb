pipeline {
    agent any
    environment {
        VERSION = "1.0.${env.BUILD_NUMBER}"
        
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "eu-central-1"

        DOCKER_USERNAME = "underdogdevops"
        DOCKER_CREDENTIALS = credentials('docker-credentials')

        ESHOPWEBMVC_IMAGE = "underdogdevops/eshopwebmvc"
        ESHOPPUBLICAPI_IMAGE = "underdogdevops/eshoppublicapi"
    }
    parameters {
        booleanParam(name: 'PLAN_TERRAFORM', defaultValue: false, description: 'Check to plan Terraform changes')
        booleanParam(name: 'APPLY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
        booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
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

    stage('Terraform Init') {
      steps {
        withCredentials(bindings: [[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
          dir(path: 'terraform') {
            sh 'echo "======Terraform Init======="'
            sh 'terraform init'
          }

        }

      }
    }

    stage('Terraform Plan') {
      when {
        expression {
          params.PLAN_TERRAFORM
        }

      }
      steps {
        withCredentials(bindings: [[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
          dir(path: 'terraform') {
            sh 'echo "=========Terraform Plan=========="'
            sh 'terraform plan'
          }

        }

      }
    }

    stage('Terraform Apply') {
      when {
        expression {
          params.APPLY_TERRAFORM
        }

      }
      steps {
        withCredentials(bindings: [[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
          dir(path: 'terraform') {
            sh 'echo "=========Terraform Apply============"'
            sh 'terraform apply -auto-approve'
          }

        }

      }
    }

    stage('Terraform Destroy') {
      when {
        expression {
          params.DESTROY_TERRAFORM
        }

      }
      steps {
        withCredentials(bindings: [[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
          dir(path: 'terraform') {
            sh 'echo "=========Terraform Destroy=========="'
            sh 'terraform destroy -auto-approve'
          }

        }

      }
    }

    stage('Build Images and Publish') {
      parallel {
        stage('Build Web UI image') {
          steps {
            dir('src/Web/') {
              script {
                def dockerTag = env.BRANCH_NAME == 'master' ? 'latest' : env.BRANCH_NAME
                // Docker login
                sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_CREDENTIALS}"
                sh "docker build -t ${ESHOPWEBMVC_IMAGE}:${dockerTag}-${VERSION} -f ./Dockerfile"
                sh "docker push ${ESHOPWEBMVC_IMAGE}:${dockerTag}-${VERSION}"
                // Docker logout
                sh "docker logout"
              }
            }
          }
        }

        stage('Build PublicApi image') {
          steps {
            dir('src/PublicApi/') {
              script {
                def dockerTag = env.BRANCH_NAME == 'master' ? 'latest' : env.BRANCH_NAME
                // Docker login
                sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_CREDENTIALS}"
                sh "docker build -t ${ESHOPPUBLICAPI_IMAGE}:${dockerTag}-${VERSION} -f ./Dockerfile"
                sh "docker push ${ESHOPPUBLICAPI_IMAGE}:${dockerTag}-${VERSION}"
                // Docker logout
                sh "docker logout"
              }
            }
          }
        }

      }
    }

  }
  
}