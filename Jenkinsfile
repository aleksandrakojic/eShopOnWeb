pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
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
        stage('Terraform Init') {
                steps {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]){
                        dir('terraform') {
                        sh 'echo "=================Terraform Init=================="'
                        sh 'terraform init'
                    }
                }
            }
        }
        stage("Terraform Plan") {
            steps {
                script {
                    if (params.PLAN_TERRAFORM) {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]){
                            dir('terraform') {
                                sh 'echo "=================Terraform Plan=================="'
                                sh 'terraform plan'
                            }
                        }
                    }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    if (params.APPLY_TERRAFORM) {
                       withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]){
                            dir('terraform') {
                                sh 'echo "=================Terraform Apply=================="'
                                sh 'terraform apply -auto-approve'
                            }
                        }
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                script {
                    if (params.DESTROY_TERRAFORM) {
                       withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]){
                            dir('terraform') {
                                sh 'echo "=================Terraform Destroy=================="'
                                sh 'terraform destroy -auto-approve'
                            }
                        }
                    }
                }
            }
        }
        stage('Build Images') {
            steps {
                parallel 'Build Web UI image': {
                    sh 'cd src/Web/'
                    docker.withRegistry(DOCKER_REGISTRY, 'docker-credentials') {
                        def dockerimage = docker.build("eshop-web:latest-${env.BRANCH_NAME}")
                        dockerimage.push()
                    }
                }, 'Build PublicApi image': {
                    sh 'cd src/PublicApi/'
                    docker.withRegistry(DOCKER_REGISTRY, 'docker-credentials') {
                        def dockerimage = docker.build("eshop-public-api:latest-${env.BRANCH_NAME}")
                        dockerimage.push()
                    }
                }
            }
        }
        // stage("Deploy to EKS") {
        //     steps {
        //         script {                    
        //             dir('kubernetes') {
        //                 sh "aws eks update-kubeconfig --name eshop-eks-cluster"
        //                 sh "kubectl apply -f deployment.yaml"
        //                 sh "kubectl apply -f service.yaml"
        //             }
        //         }
        //     }
        // }
    }
}