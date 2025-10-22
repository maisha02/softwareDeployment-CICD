pipeline {
    agent any

    stages {
        stage('Build Docker image') {
            steps {
                sh 'docker build -t python-flask-app:latest .'
            }
        }

        stage('Run container') {
            steps {
                sh 'docker run --rm -d -p 5000:5000 --name python-flask-app-run python-flask-app:latest || true'
            }
        }
    }

    post {
        always {
            sh 'docker rm -f python-flask-app-run || true'
            cleanWs()
        }
    }
}