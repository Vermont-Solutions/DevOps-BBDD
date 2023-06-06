pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Hello'
        echo 'Build '
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