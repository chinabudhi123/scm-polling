pipeline {
    agent any

    environment {
        TARGET_HOST = '13.233.124.168'        // Replace with your EC2 IP
        SSH_USER = 'ec2-user'
        SSH_CREDENTIALS_ID = 'ec2-access'     // Jenkins SSH credential ID
        REMOTE_DIR = '/home/ec2-user/scm-polling'
    }

    triggers {
        pollSCM('H/2 * * * *') // Poll GitHub every 2 minutes
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/chinabudhi123/scm-polling.git'
            }
        }

        stage('Approval Before Deployment') {
            steps {
                script {
                    input message: 'Do you approve the NGINX deployment to EC2?', ok: 'Yes, Deploy'
                }
            }
        }

        stage('Deploy to EC2 Instance') {
            steps {
                sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
                    sh """
                        echo "📁 Creating deployment folder on EC2..."
                        ssh -o StrictHostKeyChecking=no ${SSH_USER}@${TARGET_HOST} 'mkdir -p ${REMOTE_DIR}'

                        echo "📦 Copying application files to EC2..."
                        scp -o StrictHostKeyChecking=no -r * ${SSH_USER}@${TARGET_HOST}:${REMOTE_DIR}

                        echo "🚀 Running install_nginx.sh on EC2..."
                        ssh -o StrictHostKeyChecking=no ${SSH_USER}@${TARGET_HOST} 'bash ${REMOTE_DIR}/install_nginx.sh'
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ NGINX Deployment completed successfully.'
        }
        failure {
            echo '❌ Deployment failed. Please check the logs.'
        }
    }
}

