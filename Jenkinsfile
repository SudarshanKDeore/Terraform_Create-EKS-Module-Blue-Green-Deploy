pipeline {
  agent any

  environment {
    CLUSTER_NAME = "minimal-eks"
    AWS_REGION  = "us-east-1"
    APP_NAME    = "myapp"
    ACTIVE_COLOR = "blue"
    NEW_COLOR    = "green"
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/your-repo/app.git'
      }
    }

    stage('Build & Test') {
      steps {
        sh '''
        echo "Build app"
        echo "Run unit tests"
        '''
      }
    }

    stage('Deploy GREEN') {
      steps {
        sh '''
        kubectl apply -f k8s/green/deployment.yaml
        kubectl apply -f k8s/green/service.yaml
        '''
      }
    }

    stage('Health Check GREEN') {
      steps {
        sh '''
        kubectl rollout status deployment/app-green -n default
        '''
      }
    }

    stage('Switch Traffic to GREEN') {
      steps {
        sh '''
        sed -i 's/app-blue/app-green/g' k8s/ingress.yaml
        kubectl apply -f k8s/ingress.yaml
        '''
      }
    }

    stage('Monitor') {
      steps {
        sh '''
        echo "Monitoring application..."
        sleep 30
        '''
      }
    }

    stage('Cleanup BLUE') {
      when {
        expression { currentBuild.currentResult == 'SUCCESS' }
      }
      steps {
        sh '''
        kubectl delete deployment app-blue
        kubectl delete service app-blue
        '''
      }
    }
  }

  post {
    failure {
      echo "❌ Deployment failed — Rolling back"
      sh '''
      sed -i 's/app-green/app-blue/g' k8s/ingress.yaml
      kubectl apply -f k8s/ingress.yaml
      '''
    }
  }
}
