terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.10.0"
    }
  }
}
#Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

#Create EC2 Instance
resource "aws_instance" "jenkins-ec2" {
  ami = "ami-001843b876406202a"
  instance_type = "t2.micro"
  key_name = "org-mdeore-ec2jenkins"
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  user_data = file("./install_jenkins.sh")
  tags = {
    Name = "org-devops-jenkinsEC2"
  }
}

#Create security group
resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins_sg20"
  description = "Allow inbound ports 22, 8080"
  vpc_id      = "vpc-015db53bcb2d8c508"

  #Allow incoming TCP requests on port 22 from any IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
#Allow incoming TCP requests on port 443 from any IP
  ingress {
    description = "Allow HTTPS Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow incoming TCP requests on port 8080 from any IP
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
