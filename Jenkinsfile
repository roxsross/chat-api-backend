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
                        echo "prueba Npm Audit"
                    }          
                }
                stage('Semgrep') {
                    steps {
                        echo "prueba Semgrep"
                    }
                }                                                                                       
            }
        } // end parallels

        stage('Build') {
            steps {
                echo "prueba Build"
            }
        }

        stage('Container Security Scan') {
            parallel {
                stage('Trivy Scan') {
                    steps {
                        echo "prueba Trivy Scan"
                    }
                }
                stage('Linter Scan') {
                    steps {
                        echo "prueba Linter Scan"
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
