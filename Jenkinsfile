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
                        script {
                                docker.image('node:18-alpine').inside("${DOCKER_ARGS}") {
                                    try {
                                        sh 'npm install'
                                    } catch (err) {
                                        throw err
                                    }
                                }
                            }
                    }         
                }
                stage('Unit Test') {
                    steps {
                        script {
                                docker.image('node:18-alpine').inside("${DOCKER_ARGS}") {
                                    try {
                                        sh 'npm run test'
                                    } catch (err) {
                                        throw err
                                    }
                                }
                            }
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
                       sh 'python automation/trivy_vulnerability.py'
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
                        sh './automation/auto_docker.sh push'
                    }
                }
                stage('Update Compose') {
                    steps {
                        sh './automation/auto_patching.sh'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['ssh-aws']) {
                sh './automation/auto_deploy.sh'
            }
            }
        } 

        stage('Security DAST') {
            steps {
                 sh './automation/auto_security.sh dast'
            }
        }
        
        stage('Notifications') {
            steps {
                 sh './automation/auto_notify.sh'
            }
        }
    }// end stages
}// end pipeline
