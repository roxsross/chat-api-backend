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
                       echo "prueba"
                    }         
                }
                stage('Unit Test') {
                    steps {
                       echo "prueba"
                    }
                }
            }
        } 

        stage('Security Sast') {
            parallel {
                stage('Horusec') {
                    steps {
                       echo "prueba"
                    }
                }
                stage('Npm Audit') {
                    steps {
                       echo "prueba"
                    }          
                }
                stage('Semgrep') {
                    steps {
                       echo "prueba"
                    }
                }                                                                                       
            }
        } //end parallels

        stage('Build') {
                    steps {
                       echo "prueba"
                }
        }

        stage('Container Security Scan') {
            parallel {
                stage('Trivy Scan') {
                    steps {
                       echo "prueba"
                    }
                }
                stage('Linter Scan') {
                    steps {
                       echo "prueba"
                    }
                }   
            }
        }   

        stage('Update & Push') {
            parallel {        
                stage('Docker Push') {
                    steps {
                       echo "prueba"
                    }
                }
                stage('Update Compose') {
                    steps {
                       echo "prueba"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "prueba"
                // sshagent(['ssh-aws']) {
                //    
                // }
            }
        } 

        stage('Security DAST') {
            steps {
              echo "prueba"
                 }
        }
        stage('Notifications') {
            steps {
             echo "prueba"
                }
        }

    }//end stages

}// end pipeline