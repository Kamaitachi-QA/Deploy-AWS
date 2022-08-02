pipeline {
    agent any
    environment{
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key_id')
    }
       stages{
        stage ('manage configuration & deploy'){
            steps{
                sh ''' #!/bin/bash/
                git pull origin main
                cd Deploy-AWS/aws-terraform
                terraform init
                terraform plan
                terraform apply --auto-approve
                '''
            }
        }
    }
}
