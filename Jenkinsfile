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
                cd aws-terraform
                terraform init
                terraform plan
                terraform apply --auto-approve
                '''
            }
        }
          stage ('ansible playbook - swarm deploy'){
              steps{
                  sh ''' #!/bin/bash/
                  cd aws-terraform
                  ansible-playbook -i inventory playbook-swarm.yaml
                  ansible_ssh_common_args = -o StrictHostKeyChecking=no
                  '''
              }
          }
           stage ('Destroying it all!'){
              steps{
                  sh ''' #!/bin/bash/
                  sleep 30
                  terraform destroy
                  '''
              }
          }
    }
}
