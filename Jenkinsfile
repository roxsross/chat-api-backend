pipeline {
    agent any
    
    environment {
        DOCKER_HUB_LOGIN = credentials('docker-hub')
        DOCKER_ARGS = '-u root:root -v $HOME/.npm:/.npm'
    }

    stages {
        stage('Init') {
            parallel {
                stage("Install dependencies") {
                    steps {
                        echo "prueba Install dependencies"
                    }         
                }
                stage('Unit Test') {
                    steps {
                        echo "prueba Unit Test"
                    }
                }
            }
        } 

        stage('Security Sast') {
            parallel {
                stage('Horusec') {
                    steps {
                        sh './automation/auto_security.sh horusec'
                        stash includes: 'report_horusec.json', name: 'report_horusec.json'
                    }
                }
                stage('Npm Audit') {
                    steps {
                        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                            script {
                                docker.image('node:18-alpine').inside("${DOCKER_ARGS}") {
                                    try {
                                        sh 'npm install'
                                        sh 'npm audit --registry=https://registry.npmjs.org -audit-level=moderate --json > report_npmaudit.json || true'
                                    } catch (err) {
                                        throw err
                                    }
                                }
                            }
                        }
                        stash includes: 'report_npmaudit.json', name: 'report_npmaudit.json'
                    }           
                }
                stage('Semgrep') {
                    steps {
                         sh './automation/auto_security.sh semgrep'
                        stash includes: 'report_semgrep.json', name: 'report_semgrep.json'
                    }
                }                                                                                       
            }
        } // end parallels

        stage('Build') {
            steps {
                sh './automation/auto_docker.sh build'
            }
        }

        stage('Container Security Scan') {
            parallel {
                stage('Trivy Scan') {
                    steps {
                       sh './automation/auto_security.sh trivy'
                       sh 'python automation/roxs-security-tools.py report_trivy.json trivy'
                       stash includes: 'report_trivy.json', name: 'report_trivy.json'
                    }
                }
                stage('Linter Scan') {
                    steps {
                        sh './automation/auto_security.sh hadolint'
                    }
                }   
            }
        }   

        stage('Update & Push') {
            parallel {        
                stage('Docker Push') {
                    steps {
                        echo "prueba Docker Push"
                    }
                }
                stage('Update Compose') {
                    steps {
                        echo "prueba Update Compose"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "prueba Deploy"
            }
        } 

        stage('Security DAST') {
            steps {
                echo "prueba Security DAST"
            }
        }
        
        stage('Notifications') {
            steps {
                echo "prueba Notifications"
            }
        }
    }// end stages
}// end pipeline
