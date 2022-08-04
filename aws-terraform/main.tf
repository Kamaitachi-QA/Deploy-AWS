provider "aws" {
  region = "eu-west-2"
}

// Input Variables
# Taken from Leon Robinson, modified for our own use.

variable "name-prefix" {
  type        = string
  default     = "PetClinic-"
  description = "prefix for instance name"
}

variable "sshkeypairname" {
  type        = string
  description = "ssh keypair name in aws"
}



// Local Variables

locals {
  imageid      = "ami-0bd2099338bc55e6d"
  instanceType = "t3.small"
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
    description = "Services"
    from_port   = 8000
    to_port     = 8010
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    description = "Petclinic8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
      ingress {
    description = "Swarm 2377"
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_instance" "Manager" {
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
  - git clone -b Asad-swarm https://github.com/Kamaitachi-QA/Deploy-AWS.git /tmp/Deploy-AWS
  - git clone https://github.com/spring-petclinic/spring-petclinic-rest /tmp/spring-backend
  - git clone https://github.com/spring-petclinic/spring-petclinic-angular /tmp/spring-frontend
EOF

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "${var.name-prefix}-Manager-Server"
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
EOF

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "${var.name-prefix}-Worker2"
  }
}


output "amazon_pubip-Manager" {
  value = aws_instance.Manager.public_ip
}


output "amazon_pubip-Worker1" {
  description = "workers"
  value = aws_instance.worker1.public_ip
}

output "amazon_pubip-Worker2" {
  description = "workers"
  value = aws_instance.worker2.public_ip
}

resource "local_file" "config" {
    # content  = "Managers IP: \n${aws_instance.Manager.public_ip} \n \n Workers Ip: \n "
    content = "Host swarm-manager\nHostname ${aws_instance.Manager.public_ip}\n    User ubuntu\n    IdentityFile ~/AsadAWSKey.pem\n StrictHostKeyChecking no\n   UserKnownHostsFile /dev/null\n\nHost swarm-worker-1\n  Hostname ${aws_instance.worker1.public_ip}\n    User ubuntu\n   IdentityFile ~/AsadAWSKey.pem\n    StrictHostKeyChecking no\n   UserKnownHostsFile /dev/null\n\nHost swarm-worker-2\n    Hostname ${aws_instance.worker2.public_ip}\n   User ubuntu\n   IdentityFile ~/AsadAWSKey.pem\n    StrictHostKeyChecking no\n   UserKnownHostsFile /dev/null"
    filename = "${path.module}/../../.ssh/config"
}