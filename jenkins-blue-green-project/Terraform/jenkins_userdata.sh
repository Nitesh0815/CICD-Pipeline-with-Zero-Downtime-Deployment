#!/bin/bash
set -e  # Exit on error for reliability

# Update system
sudo apt-get update -y

# Install Java and Docker
sudo apt-get install -y openjdk-17-jre docker.io

# Install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y jenkins

# Permissions for Docker
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu

# Wait for Jenkins password and log it
while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]; do
  sleep 2
done
echo "--------------------------------------------------------"
echo "JENKINS_ADMIN_PASSWORD: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)"
echo "--------------------------------------------------------"

# Restart services
sudo systemctl restart docker jenkins