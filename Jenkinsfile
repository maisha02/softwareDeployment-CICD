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
                // Run detached without --rm so the container persists after the pipeline
                sh 'docker run -d -p 5000:5000 --name python-flask-app-run python-flask-app:latest'
            }
        }
    }

    // Note: post cleanup removed so containers and images persist after the pipeline
}