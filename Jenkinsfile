pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Hello'
        sh 'mvn clean install -Dlicense.skip=true'
        echo 'Build '
      }
    }

    stage('Testing') {
      parallel {
        stage('Testing') {
          steps {
            sh 'mvn sonar:sonar -Dsonar.host.url=http://sonarqube:9000 -Dlicense.skip=true'
          }
        }

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