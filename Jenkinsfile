pipeline {
    agent any
    environment{
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_KEY_ID = credentials('aws_secret_key_id')
    }
       stages{
        stage ('manage configuration & deploy'){
            steps{
                sh "/aws-terraform/terraform init"
                sh "/aws-terraform/terraform plan"
                sh "/aws-terraform/terraform apply --auto-approve" 
            }
        }
    }
}
