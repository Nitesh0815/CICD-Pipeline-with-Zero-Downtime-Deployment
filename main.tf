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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "prod_server" {
  ami           = "ami-0ecb62995f68bb549" # Ubuntu 24.04 LTS
  instance_type = "t2.micro"
  key_name      = "CICD-Pipeline-Key"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # 1. Install Docker and Nginx
              sudo apt-get update -y
              sudo apt-get install -y docker.io nginx

              # 2. Start Services
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo systemctl start nginx
              sudo systemctl enable nginx

              # 3. Fix Permissions
              # Add ubuntu to docker group
              sudo usermod -aG docker ubuntu
              # Force the socket to be accessible immediately for the ubuntu user
              sudo chown root:docker /var/run/docker.sock
              sudo chmod 660 /var/run/docker.sock

              # 4. Initial Nginx Config
              sudo bash -c 'cat > /etc/nginx/sites-available/default <<NOHOPE
              server {
                  listen 80;
                  location / {
                      proxy_pass http://127.0.0.1:8081;
                      proxy_set_header Host \$host;
                      proxy_set_header X-Real-IP \$remote_addr;
                  }
              }
              NOHOPE'

              sudo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
              sudo systemctl restart nginx
              EOF

  tags = {
    Name = "My-Production-Server"
  }
}

output "public_ip" {
  value = aws_instance.prod_server.public_ip
}