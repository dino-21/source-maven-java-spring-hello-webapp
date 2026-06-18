pipeline {
  agent none
  stages {
    stage('Checkout') {
      agent {
        docker { image 'maven:3-eclipse-temurin-21' }
      }
      steps {
        git branch: 'main', url: 'https://github.com/dino-21/source-maven-java-spring-hello-webapp.git'
      }
    }
    
    stage('Test Application') {
      agent {
        docker { image 'maven:3-eclipse-temurin-21' }
      }
      steps {
        sh 'mvn test'
      }
    }
    
    stage('Build Application') {
      agent {
        docker { image 'maven:3-eclipse-temurin-21' }
      }
      steps {
        sh 'mvn clean package -DskipTests=true'
        // TIP: 필요하다면 여기서 빌드 결과물을 stash 하세요.
        // stash name: 'war-file', includes: 'target/*.war'
      }
    }
    
    stage('Build Container Image') {
      agent { label 'controller' }
      steps {
        // unstash 'war-file'
        sh 'docker image build -t myhello:v1 .'
      }
    }
    
    stage('Tag Container Image') {
      agent { label 'controller' }
      steps {
        // 작은따옴표 중복 수정 및 변수 사용을 위해 큰따옴표(")로 변경
        sh "docker image tag myhello:v1 dino-21/myhello:v${BUILD_NUMBER}"
        sh "docker image tag myhello:v1 dino-21/myhello:latest"
      }
    }
    
    stage('Push Container Image') {
      agent { label 'controller' }
      steps {
        withDockerRegistry(credentialsId: 'docker-registry-credential', url: 'https://index.docker.io/v1/') {
          // 인자 오류 수정: 이미 태깅된 원격 저장소용 이미지만 push
          sh "docker image push dino-21/myhello:v${BUILD_NUMBER}"
          sh "docker image push dino-21/myhello:latest"
        }
      }
    }
    
    stage('Run Container') {
      agent { label 'controller' }
      steps {
        // 기존에 돌고 있는 동일한 이름의 컨테이너가 있다면 에러가 날 수 있으므로 주의 필요
        sh 'docker container run --detach --name myhello -p 80:8080 dino-21/myhello:latest'
      }
    }
  }
}
