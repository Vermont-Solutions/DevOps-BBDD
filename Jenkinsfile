pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Hello'
      }
    }
    stage('Checkout') {
      steps {
        // Clonar el repositorio
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[url: 'https://github.com/Vermont-Solutions/DevOps-BBDD.git']]])
      }
    }
        
    stage('SonarQube analysis') {
      steps {
        // Configurar SonarQube Scanner
        withSonarQubeEnv('sonarqube') {
          // Ejecutar análisis utilizando las propiedades especificadas
          sh 'sonar-scanner -Dsonar.projectKey=dvwa-sonarqube -Dsonar.projectName=sonarqube-dvwa -Dsonar.projectVersion=1.0 -Dsonar.sources=/var/jenkins_home/workspace/dvwa-sonarqube -Dsonar.language=php -Dsonar.sourceEncoding=UTF-8 -Dsonar.login=admin -Dsonar.password=Vermont2023'
        }
      }
    }

    stage('Testing') {
      parallel {
        stage('Print Tester Credential') {
          steps {
            slackSend(color: 'good', message: 'Mensaje enviado correctamente')
          }
        }

      }
    }

  }
}
