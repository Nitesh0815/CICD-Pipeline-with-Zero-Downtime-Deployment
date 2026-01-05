#!/bin/bash
set -e

# Update system
sudo apt-get update -y

# Install Docker and Nginx
sudo apt-get install -y docker.io nginx

# Permissions
sudo usermod -aG docker ubuntu
sudo chown root:docker /var/run/docker.sock

# Enable services
sudo systemctl enable nginx docker