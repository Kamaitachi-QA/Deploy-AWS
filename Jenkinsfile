pipeline {
    agent any
    environment{
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_KEY_ID = credentials('aws_secret_key_id')
    }
       stages{
        stage ('manage configuration & deploy'){
            steps{
                sh "/terraform/terraform init"
                sh "/terraform/terraform plan"
                sh "/terraform/terraform apply --auto-approve"
            }
        }
    }
}
