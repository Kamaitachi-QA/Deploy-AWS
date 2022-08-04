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
                  sleep 90
                  '''
              }
          }

          stage ('ansible playbook - swarm deploy'){
              steps{
                  sh ''' #!/bin/bash/
                  cd aws-terraform
                  ansible-playbook -i inventory playbook-swarm.yaml
                  '''
            }
          }
           
          /**stage ('Jira Comment'){
              steps{
                     jiraComment body: 'test comment', issueKey: 'QSC-19'
            }
          }*/
           
           stage ('Destroying it all!'){
              steps{
                  sh ''' #!/bin/bash/
                  sleep 1000
                  terraform destroy --auto-approve
                  '''
              }
          }
    }
}
