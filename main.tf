# 1. Define the Provider
provider "aws" {
  region = "us-east-1" # You can change this
}

# 2. Create a Security Group (Firewall)
resource "aws_security_group" "web_sg" {
  name        = "allow_web_traffic"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH access
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Launch the EC2 Instance
resource "aws_instance" "prod_server" {
  ami           = "ami-0ecb62995f68bb549" # Ubuntu 24.04 LTS (verify for your region)
  instance_type = "t2.micro"
  key_name      = "Web-Server-Key" # Make sure you created this key in AWS manually first!

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # This part automates the Docker/NGINX installation
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io nginx
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "My-Production-Server"
  }
}

# 4. Output the IP address so we can put it in GitHub Secrets
output "public_ip" {
  value = aws_instance.prod_server.public_ip
}