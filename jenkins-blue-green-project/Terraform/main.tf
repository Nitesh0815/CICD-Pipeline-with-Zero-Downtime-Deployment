provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-1508"
    key            = "cicd-pipeline/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "cicd_sg" {
  name        = var.security_group_name
  description = "Allow restricted SSH, HTTP, and Jenkins traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "CICD-Security-Group"
    Environment = "DevOps-Pipeline"
    Project     = "CICD-Demo"
  }
}

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr_policy" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins_role.name
}

resource "aws_instance" "jenkins_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.jenkins_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins_profile.name

  user_data = file("${path.module}/jenkins_userdata.sh")

  tags = {
    Name        = "Jenkins-Server"
    Environment = "DevOps-Pipeline"
    Project     = "CICD-Demo"
  }
}

resource "aws_instance" "prod_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.prod_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]

  user_data = file("${path.module}/prod_userdata.sh")

  tags = {
    Name        = "Prod-Web-Server"
    Environment = "DevOps-Pipeline"
    Project     = "CICD-Demo"
  }
}

output "jenkins_ip" {
  description = "Public IP of the Jenkins server"
  value       = aws_instance.jenkins_server.public_ip
}

output "prod_ip" {
  description = "Public IP of the production server"
  value       = aws_instance.prod_server.public_ip
}

output "jenkins_password_command" {
  description = "Command to retrieve Jenkins initial admin password"
  value       = "Run: aws ec2 get-console-output --instance-id ${aws_instance.jenkins_server.id} --region ${var.region} --query 'Output' --output text | grep JENKINS_ADMIN_PASSWORD"
}