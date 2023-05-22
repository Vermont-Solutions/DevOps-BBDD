pipeline {
    agent any
    
    stages {
        stage('Levantar contenedor') {
            steps {
                script {
                    docker.image('vermontjc/oracle19').run('-d -p 1521:1521 --name oracle19')
                }
                 
            }
        }
        
        stage('Realizar pruebas') {
            steps {
               echo 'Hello World'
            }
        }
        
        stage('Detener contenedor') {
            steps {
                sh 'docker stop oracle19'
                sh 'docker rm oracle19'
            }
        }
    }
}
