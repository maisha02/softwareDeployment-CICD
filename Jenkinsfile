pipeline {
    // Use a generic agent; some Jenkins instances don't allow the 'docker' agent block.
    agent any

    environment {
        TEST_REPORT = 'junit-results.xml'
    }

    stages {
        stage('Run tests') {
            steps {
                script {
                    // If docker is available on the node, run tests inside the official Python image
                    def dockerAvailable = (sh(script: 'which docker >/dev/null 2>&1', returnStatus: true) == 0)
                    if (dockerAvailable) {
                        echo 'Docker detected on agent — running tests inside python:3.12-slim container'
                        // Mount workspace into the container so results are written back to Jenkins workspace
                        sh "docker run --rm -v ${WORKSPACE}:/workspace -w /workspace python:3.12-slim bash -lc \"pip install --no-cache-dir -r requirements.txt && pytest --junitxml=${TEST_REPORT} -q\""
                    } else {
                        echo 'Docker not available — running tests directly on the agent'
                        // Try running tests directly on the node. Ensure Python is available on the agent.
                        sh 'python3 -m venv venv || true'
                        sh '. venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt && pytest --junitxml=${TEST_REPORT} -q'
                    }
                }
            }
            post {
                always {
                    // Publish JUnit report (will fail the stage if no results found)
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