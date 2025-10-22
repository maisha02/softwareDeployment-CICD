pipeline {
    agent {
        docker {
            image 'python:3.12-slim'
            args '-u --rm'
        }
    }

    environment {
        VENV_DIR = 'venv'
        TEST_REPORT = 'junit-results.xml'
    }

    stages {
        stage('Prepare') {
            steps {
                sh 'python -m venv ${VENV_DIR}'
                sh "source ${VENV_DIR}/bin/activate && pip install --upgrade pip && pip install -r requirements.txt"
            }
        }

        stage('Run tests') {
            steps {
                // Run pytest and generate JUnit XML for Jenkins
                sh "source ${VENV_DIR}/bin/activate && pytest --junitxml=${TEST_REPORT} -q"
            }
            post {
                always {
                    junit allowEmptyResults: false, testResults: '${TEST_REPORT}'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
