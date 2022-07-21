provider "aws" {
  region = "eu-west-2"
}

// Input Variables

variable "name-prefix" {
  type        = string
  default     = "terraform"
  description = "prefix for instance name"
}

variable "sshkeypairname" {
  type = string
  description = "ssh keypair name in aws"
}

variable "securitygrouplist" {
  type = list
  description = "security group for instances"
}


// Local Variables

locals {
  imageid = "ami-0bd2099338bc55e6d"  
  instanceType = "t3.small"
}



resource "aws_instance" "kubernetes" {
  ami           = local.imageid
  instance_type = local.instanceType
  key_name = var.sshkeypairname
  vpc_security_group_ids= var.securitygrouplist
  user_data = <<EOF
#cloud-config
sources:
  ansible:
    source "ppa:ansible/ansible"
packages:
  - software-properties-common
  - ansible
runcmd:
  - git clone https://github.com/Crush-Steelpunch/Minikube-Aws-Env.git /tmp/Minikube-Aws-Env

EOF

  tags = {
    Name = "${var.name-prefix}-minikube"
  }
}



output "amazon_pubip" {
  value = aws_instance.kubernetes.public_ip
}
