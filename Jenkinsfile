pipeline {
  agent any
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
          sh 'docker run -d -p 1525:1521 -p 5505:5500 --name=oracle11Test -e ORACLE_PWD=Password123$ oracleinanutshell/oracle-xe-11g:latest'
          // Sleep for 1 minute
          sh 'sleep 300'
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