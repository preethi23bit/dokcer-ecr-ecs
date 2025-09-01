pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = "123456789012"   // 🔹 Replace with your AWS Account ID
        AWS_REGION = "ap-south-1"         // 🔹 Replace with your AWS region
        ECR_REPO = "myapp-repo"           // 🔹 Replace with your ECR repo name
        IMAGE_TAG = "latest"
    }

    stages {
        stage('1. Clone Code') {
            steps {
                git 'https://github.com/your-username/myapp.git'   // 🔹 Replace with your GitHub URL
            }
        }

        stage('2. Run Tests') {
            steps {
                sh 'npm install'
                sh 'npm test'
            }
        }

        stage('3. Build Docker Image') {
            steps {
                sh 'docker build -t myapp .'
            }
        }

        stage('4. Save Artifact') {
            steps {
                sh 'docker save myapp > myapp.tar'
                archiveArtifacts artifacts: 'myapp.tar'
            }
        }

        stage('5. Push to AWS ECR') {
            steps {
                sh '''
                  aws ecr get-login-password --region $AWS_REGION \
                  | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                  
                  docker tag myapp:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
                  docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
                '''
            }
        }

        stage('6. Deploy to ECS') {
            steps {
                sh '''
                  aws ecs update-service \
                    --cluster myapp-cluster \
                    --service myapp-service \
                    --force-new-deployment
                '''
            }
        }
    }
}
