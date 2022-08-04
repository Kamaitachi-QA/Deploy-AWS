# Deploy an AWS instance


## Deploy the AWS instance

```bash
cd aws-terraform
terraform init
terraform plan 
terraform apply
```

## SSH into the instance and deploy docker

```bash
cd /tmp/Deploy-AWS/ansible-playbook
ansible-playbook dockerinstall.yaml
```

Architecture
Technologies
Docker
Docker and Docker Swarm was used to build images the services and  deploy the application.

Terraform
Terraform is an infrastructure as code software. This was used to provision the network environment which was used to host the application.

Jenkins
Jenkins is a CI Server, it was used to automate deployment once changes were made on the GitHub repository.

AWS
AWS is the cloud provider used to deploy the application in the production environment.

Ansible
Ansible is for Configuration Management, to install docker and run docker swarm.

Jira
Project Management Tool, to help plan and co-ordinate team towards objectives and goals, and keep trakc of our progress.

##Project planning - Jira


