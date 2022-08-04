# Deploy an AWS instance

This Project is fully automated once the required set-up steps are taken. 

Required Setup:
Update the terraform.tfvars with your own AWS Key.
And update main.tf with correct file location of your AWS key. 
Set Up a Jenkins Server, with Terraform pre installed.

----------------------------------------------------------------------------------------------------------------------

#Architecture
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
https://lback1.atlassian.net/jira/software/projects/QSC/boards/4



