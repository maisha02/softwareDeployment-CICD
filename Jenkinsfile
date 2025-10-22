pipeline {
    agent any

    environment {
        TEST_REPORT = 'junit-results.xml'
    }

    stages {
        stage('Run tests') {
            steps {
                script {
                    // Notify GitHub that build is pending (guarded in case plugin isn't installed)
                    try {
                        githubNotify(context: 'CI / Tests', status: 'PENDING', description: 'Tests running')
                    } catch (err) {
                        echo "githubNotify not available: ${err}"
                    }

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
                    script {
                        try {
                            githubNotify(context: 'CI / Tests', status: 'SUCCESS', description: 'Tests passed')
                        } catch (err) {
                            echo "githubNotify not available: ${err}"
                        }
                    }
                }
                failure {
                    script {
                        try {
                            githubNotify(context: 'CI / Tests', status: 'FAILURE', description: 'Tests failed')
                        } catch (err) {
                            echo "githubNotify not available: ${err}"
                        }
                    }
                }
                always {
                    script {
                        if (fileExists("${TEST_REPORT}")) {
                            junit allowEmptyResults: false, testResults: "${TEST_REPORT}"
                        } else {
                            echo "No test report found at ${TEST_REPORT}; skipping junit step."
                        }
                    }
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
