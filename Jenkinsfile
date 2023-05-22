pipeline {
    agent any
    
    stages {
        stage('Levantar contenedor') {
            steps {
                script {
                    docker.image('vermontjc/oracle19').run('-d -p 1521:1521 --name oracle19')
                }
                 echo 'Hello World'
            }
        }
        
        stage('Realizar pruebas') {
            steps {
                // Aquí puedes agregar pasos para realizar pruebas en el contenedor
                // Puedes ejecutar comandos dentro del contenedor o acceder a servicios expuestos por él
                // Ejemplo:
                // sh 'docker exec oracle19 ls'
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
