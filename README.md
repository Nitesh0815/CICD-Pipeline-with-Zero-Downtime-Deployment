# 🚀 Automated Zero-Downtime Blue-Green Deployment

This repository contains a full-stack DevOps project that automates the deployment of a web application on **AWS** using **Terraform**, **Docker**, and **GitHub Actions**. It features a custom **Blue-Green deployment strategy** to ensure the website stays live (zero downtime) even while updates are being pushed.



---

## 🏗 System Architecture
The pipeline follows a modern CI/CD flow:
1.  **Infrastructure:** Terraform provisions an AWS EC2 instance and configures security groups.
2.  **Continuous Integration:** GitHub Actions builds a Docker image and pushes it to Docker Hub.
3.  **Continuous Deployment:** GitHub Actions SSHes into the EC2, identifies the inactive environment, deploys the new container, and flips the **Nginx** switch.



---

## 🛠 Features
- **Infrastructure as Code (IaC):** Repeatable server setup using Terraform.
- **Reverse Proxy:** Nginx routes traffic to the correct Docker container.
- **Zero-Downtime:** Automated Blue-Green switching logic.
- **Self-Healing:** Scripted health checks ensure the new version is running before killing the old one.
- **Automated Cleanup:** Automatic removal of old Docker images to save disk space.

---

## 📝 Steps Taken (The Journey)

### Phase 1: Automated Provisioning
* Created `main.tf` to define the AWS environment.
* Used **User Data** scripts to pre-install Docker and Nginx, ensuring the server is ready for deployment the moment it's created.

### Phase 2: Containerization
* Developed a `Dockerfile` based on `nginx:alpine` for a lightweight, secure application footprint.
* Configured Docker Hub integration for version-controlled image storage.

### Phase 3: Blue-Green Logic Development
* Wrote a custom Bash script within the GitHub Actions workflow to handle environment detection.
* **The Logic:** If `app-blue` is running, deploy to `app-green` (Port 8082). If `app-green` is running, deploy to `app-blue` (Port 8081).

### Phase 4: Troubleshooting & Optimization
* **Nginx Fixes:** Solved a `502 Bad Gateway` issue by correctly escaping Nginx variables (`\$host`) inside the deployment script.
* **Permission Management:** Fixed Docker socket permission issues to allow non-root deployments.

---

## 🚀 Deployment Instructions

### 1. Prerequisites
- AWS Account & CLI configured.
- Docker Hub account.
- GitHub repository secrets configured:
  - `HOST_IP`: Your EC2 Public IP.
  - `EC2_SSH_KEY`: Your `.pem` private key.
  - `DOCKER_USERNAME`: Docker Hub ID.
  - `DOCKER_PASSWORD`: Docker Hub Token.

### 2. Infrastructure
```bash
terraform init
terraform apply -auto-approve
```

### 3. Application
```bash
git add .
git commit -m "Deploying Version 2.0"
git push origin main
```

---

## 📊 Project Status
- [x] Infrastructure Provisioned
- [x] Dockerization Complete
- [x] CI/CD Pipeline Fully Automated
- [x] Blue-Green Switching Logic Active
- [ ] SSL/HTTPS (Upcoming Phase)

---

## 📄 License
This project is open-source and available under the MIT License.

---

### What's next?
Now that you have your project and your documentation finished:
1.  **Create a new file** in your repository called `README.md`.
2.  **Paste the code above** into it.
3.  **Commit and push** it.
4.  Go to your GitHub repository page and see how professional it looks!

**Would you like me to help you create a "Project Architecture" diagram using text symbols to include in the README as well?**