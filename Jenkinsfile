pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Hello'
        sh 'mvn clean install -Dlicense.skip=true'
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