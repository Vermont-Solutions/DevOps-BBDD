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
            echo 'The tester is ${TESTER}'
            sleep 10
          }
        }

        stage('Print build number') {
          steps {
            echo 'This is build number ${BUILD_ID}'
            sleep 20
          }
        }

      }
    }

  }
}