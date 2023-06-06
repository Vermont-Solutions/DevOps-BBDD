pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Hello'
        echo 'Build '
        withSonarQubeEnv('sonarqube') {
          waitForQualityGate true
        }

      }
    }

    stage('Testing') {
      parallel {
        stage('Print Tester Credential') {
          steps {
            slackSend(color: 'good', message: "Mensaje enviado correctamente")
          }
        }
      }
    }
  }
}
