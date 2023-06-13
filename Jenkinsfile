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
          // Checkout the code from the provided GitHub repository
            git 'https://github.com/Vermont-Solutions/DevOps-BBDD.git'
        }
      }

        stage('Check and Install SonarScanner') {
            steps {
                script {
                    // Check if SonarScanner is installed
                    def sonarScanner = sh(script: 'which sonar-scanner || echo "not found"', returnStdout: true).trim()
                    if (sonarScanner == 'not found') {
                        // Install SonarScanner if not found, modify this section to suit your environment
                        echo 'SonarScanner not found, installing...'
                        sh 'curl -Lo /tmp/sonarscanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-latest.zip'
                        sh 'unzip /tmp/sonarscanner.zip -d /opt'
                        sh 'ln -s /opt/sonar-scanner-*/bin/sonar-scanner /usr/local/bin/sonar-scanner'
                        sh 'rm /tmp/sonarscanner.zip'
                    } else {
                        echo 'SonarScanner found, proceeding with the build.'
                    }
                }
            }
        }

        stage('SonarQube analysis') {
            steps {
                // Assuming you have SonarScanner correctly set up
                // You would need to replace 'my_sonar' with the actual ID of your SonarQube installation in Jenkins
                withSonarQubeEnv('my_sonar') {
                    sh 'sonar-scanner'
                }
            }
        }
    }

    post {
        always {
            // Capture results regardless of the build status
            // 'my_sonar' should be replaced with the actual ID of your SonarQube installation in Jenkins
            sonarQubeScanner: waitForQualityGate('my_sonar')
        }
    }
}
    
