pipeline {
  agent any
  environment {
    SONARQUBE_SCANNER_HOME = tool name: 'SonarQube Scanner'
    SONAR_HOST_URL = 'http://localhost:9000'
    SONAR_AUTH_TOKEN = credentials('sqa_7f39146dfef54d308ea719c95524b3fda1feafd5') // Asegúrate de que este ID de credencial existe en Jenkins
  }
  stages {
    stage('Clone Git repository') {
      steps {
        git(branch: 'main', url: 'https://github.com/Vermont-Solutions/DevOps-BBDD.git')
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh 'docker build -t my-docker-image .'
        }
      }
    }

    stage('Run and Sleep') {
      steps {
        script {
          sh 'docker run -d -p 1525:1521 -p 5505:5500 --name=my-container -e ORACLE_PWD=Password123$ oracleinanutshell/oracle-xe-11g:latest'
          // Sleep for 5 minutes to ensure the container is fully up
          sh 'sleep 300'
        }
      }
    }

    stage('SonarQube analysis') {
      steps {
        withSonarQubeEnv('SonarQube') { // Nombre de la configuración de SonarQube en Jenkins
          sh "${SONARQUBE_SCANNER_HOME}/bin/sonar-scanner \
            -Dsonar.projectKey=your-project-key \
            -Dsonar.sources=. \
            -Dsonar.host.url=${SONAR_HOST_URL} \
            -Dsonar.login=${SONAR_AUTH_TOKEN}"
        }
      }
    }

    stage('Stop and Remove Container') {
      steps {
        script {
          sh 'docker stop my-container'
          sh 'docker rm my-container'
        }
      }
    }
  }
}
