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
        checkout([$class: 'GitSCM', branches: [[name: '*/desarrollo']], userRemoteConfigs: [[url: 'https://github.com/Vermont-Solutions/DevOps-BBDD.git']]])
      }
    }
    stage('SonarQube analysis1') {
      environment {
        scannerHome = tool 'SonarQubeScanner'
      }
      steps {
        withSonarQubeEnv('sonarqubeScanner') {
          sh '${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=dvwa-sonarqube -Dsonar.projectName=sonarqube-dvwa -Dsonar.projectVersion=1.0 -Dsonar.sources=/var/jenkins_home/workspace/dvwa-sonarqube -Dsonar.language=php -Dsonar.sourceEncoding=UTF-8 -Dsonar.login=admin -Dsonar.password=Vermont2023'
        }

      }
    }

    stage('Print Tester Credential') {
      steps {
        slackSend(color: 'good', message: 'Mensaje enviado correctamente')
      }
    }

  }
}
