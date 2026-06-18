pipeline {
  agent none
  stages {
    stage('Checkout') {
      agent { docker { image 'maven:3-eclipse-temurin-21' } }
      steps {
        git branch: 'main', url: 'https://github.com/dino-21/source-maven-java-spring-hello-webapp.git'
      }
    }
    stage('Test Application') {
      agent { docker { image 'maven:3-eclipse-temurin-21' } }
      steps { sh 'mvn test' }
    }
    stage('Build Application') {
      agent { docker { image 'maven:3-eclipse-temurin-21' } }
      steps {
        sh 'mvn clean package -DskipTests=true'
        stash name: 'war-file', includes: 'target/*.war'
      }
    }
    stage('Build Container Image') {
      agent { label 'controller' }
      steps {
        unstash 'war-file'
        sh 'docker image build -t myhello:v1 .'
      }
    }
    stage('Tag Container Image') {
      agent { label 'controller' }
      steps {
        sh "docker image tag myhello:v1 ysboo1979053/myhello:v${BUILD_NUMBER}"
        sh "docker image tag myhello:v1 ysboo1979053/myhello:latest"
      }
    }
    stage('Push Container Image') {
      agent { label 'controller' }
      steps {
        withDockerRegistry(credentialsId: 'docker-registry-credential', url: 'https://index.docker.io/v1/') {
          sh "docker image push ysboo1979053/myhello:v${BUILD_NUMBER}"
          sh "docker image push ysboo1979053/myhello:latest"
        }
      }
    }
    stage('Run Container') {
      agent { label 'controller' }
      steps {
        sh 'ansible-playbook playbook.yaml'
      }
    }
  }
}
