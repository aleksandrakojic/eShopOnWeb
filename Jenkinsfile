pipeline {
    agent any
    environment {
        AWS_CREDENTIALS = credentials('aws-credentials')
        AWS_DEFAULT_REGION = "eu-central-1"
        DOCKER_REGISTRY = "https://hub.docker.com/"
        VERSION = "1.0.${env.BUILD_NUMBER}"
    }
    parameters {
        booleanParam(name: 'PLAN_TERRAFORM', defaultValue: false, description: 'Check to plan Terraform changes')
        booleanParam(name: 'APPLY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
        booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
    }

  stages {
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
            sh 'echo "=================Terraform Init=================="'
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
            sh 'echo "=================Terraform Plan=================="'
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
            sh 'echo "=================Terraform Apply=================="'
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
            sh 'echo "=================Terraform Destroy=================="'
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
                sh 'docker build -t eshop-web:latest-${env.BRANCH_NAME} .'
                withDockerRegistry(url: env.DOCKER_REGISTRY, credentialsId: 'docker-credentials') {
                  sh 'docker push eshop-web:latest-${env.BRANCH_NAME}'
                }
              }
            }
          }
        }

        stage('Build PublicApi image') {
          steps {
            dir('src/PublicApi/') {
              script {
                sh 'docker build -t eshop-public-api:latest-${env.BRANCH_NAME} .'
                withDockerRegistry(url: env.DOCKER_REGISTRY, credentialsId: 'docker-credentials') {
                  sh 'docker push eshop-public-api:latest-${env.BRANCH_NAME}'
                }
              }
            }
          }
        }

      }
    }

  }
  
}