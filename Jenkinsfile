pipeline {
    agent any
    environment{
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key_id')
        ANSIBLE_HOST_KEY_CHECKING='False'
    }
    
    
       stages{
             stage ('Destroy v1'){
              steps{
                  sh ''' #!/bin/bash/
                  cd aws-terraform
                  terraform destroy --auto-approve
                  '''
              }
             }
           
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
          stage ('night night'){
              steps{
                  sh ''' #!/bin/bash/
                  sleep 60
                  '''
              }
          }

          stage ('ansible playbook - swarm deploy'){
              steps{
                  sh ''' #!/bin/bash/
                  cd aws-terraform
                  sudo chmod 666 /var/run/docker.sock
                  ansible-playbook -i inventory playbook-swarm.yaml
                  '''
            }
          }
           
           stage ('Destroying it all!'){
              steps{
                  sh ''' #!/bin/bash/
                  sleep 10
                  terraform destroy --auto-approve
                  '''
              }
          }
    }
}
