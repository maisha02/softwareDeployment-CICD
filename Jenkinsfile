pipeline {
    agent any

    environment {
        TEST_REPORT = 'junit-results.xml'
    }

    stages {
        pipeline {
            agent any

            stages {
                stage('Prepare') {
                    steps {
                        script {
                            echo 'Preparing agent: attempting to install git and docker if possible (requires sudo)'
                            // Try apt-get first (Debian/Ubuntu) — if not available, continue
                            sh '''
                                if command -v apt-get >/dev/null 2>&1; then
                                    sudo apt-get update -y || true
                                    sudo apt-get install -y git docker.io || true
                                else
                                    echo 'apt-get not found; skipping package install'
                                fi
                            '''
                        }
                    }
                }

                stage('Build Docker image') {
                    steps {
                        script {
                            // Build a Docker image named python-flask-app
                            if (sh(script: 'which docker >/dev/null 2>&1', returnStatus: true) == 0) {
                                sh "docker build -t python-flask-app:latest ."
                            } else {
                                echo 'Docker not available on agent; skipping docker build'
                            }
                        }
                    }
                }

                stage('Run container') {
                    steps {
                        script {
                            if (sh(script: 'which docker >/dev/null 2>&1', returnStatus: true) == 0) {
                                // Run container in detached mode, map port 5000
                                sh "docker run --rm -d -p 5000:5000 --name python-flask-app-run python-flask-app:latest || true"
                                echo 'Container started (if image existed).'
                            } else {
                                echo 'Docker not available on agent; cannot run container.'
                            }
                        }
                    }
                }
            }

            post {
                always {
                    script {
                        // Try stopping and removing container if it exists
                        if (sh(script: 'which docker >/dev/null 2>&1', returnStatus: true) == 0) {
                            sh "docker rm -f python-flask-app-run || true"
                        }
                        cleanWs()
                    }
                }
            }
        }
