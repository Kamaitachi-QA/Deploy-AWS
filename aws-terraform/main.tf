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


resource "aws_security_group" "SecGroup" {
  name = "SecGroup"

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
    description = "Port-8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_instance" "PetClinic-FE" {
  ami                    = local.imageid
  instance_type          = local.instanceType
  key_name               = var.sshkeypairname
  vpc_security_group_ids = [aws_security_group.SecGroup.id]
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
  - cd /tmp/back-end
  - sudo chmod 666 /var/run/docker.sock
  - docker run -d -p 9966:9966 springcommunity/spring-petclinic-rest
  - cd /tmp/front-end
  - docker build -t spring-petclinic-angular:latest .
  - docker run --rm -p 8080:8080 spring-petclinic-angular:latest

EOF

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "${var.name-prefix}-FrontEnd-Server"
  }
}


output "amazon_pubip-frontend" {
  value = aws_instance.PetClinic-FE.public_ip
}
