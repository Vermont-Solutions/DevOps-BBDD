pipeline {
  agent any
  environment {
    SONARQUBE_SCANNER_HOME = tool name: 'SonarQube Scanner'
    SONAR_HOST_URL = 'http://localhost:9000'
    SONAR_AUTH_TOKEN = credentials('sonar-auth-token') // Asegúrate de que este ID de credencial existe en Jenkins
  }
  stages {
    stage('Clone Git repository') {
      steps {
        script {
          // Información de debug
          sh 'echo "Clonando el repositorio desde GitHub"'
          sh 'git --version'
          git(branch: 'main', url: 'https://github.com/Vermont-Solutions/DevOps-BBDD.git')
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          // Información de debug
          sh 'echo "Construyendo la imagen de Docker"'
          sh 'docker --version'
          sh 'docker build -t my-docker-image .'
        }
      }
    }

    stage('Run and Sleep') {
      steps {
        script {
          // Información de debug
          sh 'echo "Ejecutando el contenedor y esperando"'
          sh 'docker run -d -p 1525:1521 -p 5505:5500 --name=my-container -e ORACLE_PWD=Password123$ oracleinanutshell/oracle-xe-11g:latest'
          // Sleep for 5 minutes to ensure the container is fully up
          sh 'sleep 300'
        }
      }
    }

    stage('SonarQube analysis') {
      steps {
        withSonarQubeEnv('SonarQube') { // Nombre de la configuración de SonarQube en Jenkins
          // Información de debug
          sh 'echo "Iniciando análisis con SonarQube"'
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
          // Información de debug
          sh 'echo "Deteniendo y eliminando el contenedor de Docker"'
          sh 'docker stop my-container'
          sh 'docker rm my-container'
        }
      }
    }
  }
}
