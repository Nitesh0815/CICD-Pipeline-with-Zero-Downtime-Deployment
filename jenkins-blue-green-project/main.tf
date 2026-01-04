provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web_sg" {
  name        = "allow_web_traffic"
  description = "Allow SSH and HTTP"

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
}

# 1. Jenkins Build Server
resource "aws_instance" "jenkins_server" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro" # Note: t2.small is better for Jenkins if you have credits
  key_name      = "CICD-Pipeline-Key"
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y openjdk-17-jre docker.io
              
              # Install Jenkins
              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
              echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get update -y
              sudo apt-get install -y jenkins

              # Permissions
              sudo usermod -aG docker jenkins
              sudo usermod -aG docker ubuntu
              
              # Wait for Jenkins to generate the initial password
              while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]; do
                sleep 2
              done

              # Print password to the system log so it appears in 'aws ec2 get-console-output'
              echo "--------------------------------------------------------"
              echo "JENKINS_ADMIN_PASSWORD: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)"
              echo "--------------------------------------------------------"
              
              sudo systemctl restart docker jenkins
              EOF

  tags = { Name = "Jenkins-Server" }
}

# 2. Production Web Server
resource "aws_instance" "prod_server" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"
  key_name      = "CICD-Pipeline-Key"
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io nginx
              sudo usermod -aG docker ubuntu
              sudo chown root:docker /var/run/docker.sock
              sudo systemctl enable nginx docker
              EOF

  tags = { Name = "Prod-Web-Server" }
}

output "jenkins_ip" { value = aws_instance.jenkins_server.public_ip }

output "prod_ip" { value = aws_instance.prod_server.public_ip }

output "how_to_get_jenkins_password" {
  value = "Run this command in 2 minutes: aws ec2 get-console-output --instance-id ${aws_instance.jenkins_server.id} --region us-east-1 --query 'Output' --output text | grep JENKINS_ADMIN_PASSWORD"
}