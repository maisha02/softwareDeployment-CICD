pipeline {
    agent any

    environment {
        TEST_REPORT = 'junit-results.xml'
    }

    stages {
        stage('Run tests') {
            steps {
                script {
                    // Notify GitHub that build is pending
                    githubNotify(context: 'CI / Tests', status: 'PENDING', description: 'Tests running')

                    def dockerAvailable = (sh(script: 'which docker >/dev/null 2>&1', returnStatus: true) == 0)
                    if (dockerAvailable) {
                        echo 'Docker detected on agent — running tests inside python:3.12-slim container'
                        sh "docker run --rm -v ${WORKSPACE}:/workspace -w /workspace python:3.12-slim bash -lc \"pip install --no-cache-dir -r requirements.txt && pytest --junitxml=${TEST_REPORT} -q\""
                    } else {
                        echo 'Docker not available — running tests directly on the agent'
                        sh 'python3 -m venv venv || true'
                        sh '. venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt && pytest --junitxml=${TEST_REPORT} -q'
                    }
                }
            }
            post {
                success {
                    githubNotify(context: 'CI / Tests', status: 'SUCCESS', description: 'Tests passed')
                }
                failure {
                    githubNotify(context: 'CI / Tests', status: 'FAILURE', description: 'Tests failed')
                }
                always {
                    junit allowEmptyResults: false, testResults: "${TEST_REPORT}"
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
