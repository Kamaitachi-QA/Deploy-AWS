provider "aws" {
  region = "eu-west-2"
}

// Input Variables
# Taken from Leon Robinson, modified for our own use.

variable "name-prefix" {
  type        = string
  default     = "PetClinic"
  description = "prefix for instance name"
}

variable "sshkeypairname" {
  type        = string
  description = "ssh keypair name in aws"
}



// Local Variables

locals {
  imageid      = "ami-0bd2099338bc55e6d"
  instanceType = "t3.medium"
}

 resource "local_file" "hosts" {
    content = "[manager] \n${aws_instance.Manager.public_ip} \n[workers] \n${aws_instance.worker1.public_ip} \n${aws_instance.worker2.public_ip} \n[workers:vars] \nansible_ssh_private_key_file=/lukesAWSkeypair.pem \nansible_user=ubuntu \n[manager:vars] \nansible_ssh_private_key_file=/lukesAWSkeypair.pem \nansible_user=ubuntu" 

 
#   template = "${file("${path.module}/hosts.tpl")}"
#   vars = {
#       manager = aws_instance.Manager.public_ip
#       worker1 = aws_instance.worker1.public_ip
#       worker2 = aws_instance.worker2.public_ip
    
  filename = "${path.module}/inventory/hosts"
 }

resource "aws_security_group" "SGroup" {
  name = "SGroup"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    description = "port-2377"
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

  ingress {
    description = "Port-8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_instance" "Manager" {
  ami                    = local.imageid
  instance_type          = local.instanceType
  key_name               = var.sshkeypairname
  vpc_security_group_ids = [aws_security_group.SGroup.id]
  user_data              = <<EOF
#cloud-config
sources:
  ansible:
    source "ppa:ansible/ansible"
packages:
  - software-properties-common
  - ansible
runcmd:
  - git clone https://github.com/Kamaitachi-QA/Deploy-AWS.git /tmp/Deploy-AWS
  - git clone https://github.com/Kamaitachi-QA/back-end.git /tmp/back-end
  - git clone https://github.com/Kamaitachi-QA/front-end.git /tmp/front-end
  - cd /tmp/Deploy-AWS/ansible-playbook
  - ansible-playbook dockerinstall.yaml
  - sudo chmod 666 /var/run/docker.sock
  - cd /tmp/back-end
  - docker run -d -p 9966:9966 springcommunity/spring-petclinic-rest
  - cd /tmp/front-end
  - docker build -t spring-petclinic-angular:latest .
  - docker run --rm -p 8080:8080 spring-petclinic-angular:latest

EOF


  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "${var.name-prefix}-Manager"
  }
}

resource "aws_instance" "worker1" {
  ami                    = local.imageid
  instance_type          = local.instanceType
  key_name               = var.sshkeypairname
  vpc_security_group_ids = [aws_security_group.SGroup.id]
  user_data              = <<EOF
#cloud-config
sources:
  ansible:
    source "ppa:ansible/ansible"
packages:
  - software-properties-common
  - ansible
runcmd:
  - git clone https://github.com/Kamaitachi-QA/Deploy-AWS.git /tmp/Deploy-AWS
  - cd /tmp/Deploy-AWS/ansible-playbook
  - ansible-playbook dockerinstall.yaml
  # - sudo chmod 666 /var/run/docker.sock
EOF

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "${var.name-prefix}-Worker1"
  }
}

resource "aws_instance" "worker2" {
  ami                    = local.imageid
  instance_type          = local.instanceType
  key_name               = var.sshkeypairname
  vpc_security_group_ids = [aws_security_group.SGroup.id]
  user_data              = <<EOF
#cloud-config
sources:
  ansible:
    source "ppa:ansible/ansible"
packages:
  - software-properties-common
  - ansible
runcmd:
  - git clone https://github.com/Kamaitachi-QA/Deploy-AWS.git /tmp/Deploy-AWS
  - cd /tmp/Deploy-AWS/ansible-playbook
  - ansible-playbook dockerinstall.yaml
  #- sudo chmod 666 /var/run/docker.sock
EOF

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "${var.name-prefix}-Worker2"
  }
}

output "amazon_pubip-Manager" {
  description = "manager"
  value = aws_instance.Manager.public_ip
}

output "amazon_pubip-worker1" {
  description = "workers"
  value = aws_instance.worker1.public_ip
}

output "amazon_pubip-Worker2" {
  description = "workers"
  value = aws_instance.worker2.public_ip
}
