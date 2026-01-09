# 🚀 Automated Zero-Downtime Blue-Green Deployment  
### (Implemented Using **GitHub Actions** & **Jenkins**)

This repository demonstrates a **production-ready CI/CD pipeline** for deploying a containerized web application on **AWS EC2** with **zero downtime** using a **Blue-Green deployment strategy**.

The same project has been **successfully implemented using two CI/CD tools**:

- ✅ **GitHub Actions (Cloud-native CI/CD)**
- ✅ **Jenkins (Self-hosted CI/CD on AWS)**

This showcases flexibility, real-world DevOps skills, and tool-agnostic pipeline design.

---

## 🏗️ System Architecture Overview

### Common Architecture (Both Pipelines)
- **Infrastructure Provisioning:** Terraform
- **Compute:** AWS EC2 (Ubuntu)
- **Containerization:** Docker + Docker Hub
- **Deployment Strategy:** Blue-Green (Zero Downtime)
- **Web Server:** Nginx
- **Ports:**
  - `8081` → Blue Environment
  - `8082` → Green Environment

---

## 🧰 Tools & Technologies Used

- **AWS EC2**
- **Terraform (IaC)**
- **Docker & Docker Hub**
- **Nginx**
- **GitHub Actions**
- **Jenkins**
- **Shell Scripting**
- **Blue-Green Deployment**

---

## 🔁 CI/CD Implementation Methods

## 🟦 Method 1: CI/CD Using GitHub Actions

### Workflow Summary
1. Developer pushes code to `main` branch
2. GitHub Actions pipeline triggers automatically
3. Docker image is built and pushed to Docker Hub
4. Pipeline SSHs into EC2
5. Detects inactive environment (Blue/Green)
6. Deploys new container
7. Switches traffic with **zero downtime**

### Key Highlights
- Fully cloud-native CI/CD
- No server maintenance required
- Secure secrets management using GitHub Secrets
- Automated cleanup of old containers/images

---

## 🟥 Method 2: CI/CD Using Jenkins (Self-Hosted)

### Jenkins Infrastructure
- Jenkins server provisioned using **Terraform**
- Jenkins runs on a dedicated **AWS EC2 instance**
- IAM Role attached for Docker & ECR access
- Jenkins installed via **user-data script**

### Jenkins Pipeline Flow
1. Jenkins pulls source code from GitHub
2. Builds Docker image
3. Pushes image to Docker Hub
4. Connects to Production EC2 using SSH
5. Executes **Blue-Green deployment logic**
6. Ensures **zero downtime deployment**

### Jenkinsfile Responsibilities
- Docker image build
- Docker Hub authentication (Jenkins Credentials)
- Blue-Green deployment logic
- Post-build success/failure handling

```groovy
pipeline {
    agent any
    stages {
        stage('Checkout') { ... }
        stage('Build Docker Image') { ... }
        stage('Push to DockerHub') { ... }
        stage('Blue-Green Deployment') { ... }
    }
}
```

### Why Jenkins?
- Demonstrates enterprise-grade CI/CD
- Full pipeline control
- Widely used in real production environments

---

## 🔐 Security & IAM
- Custom **Security Group**
  - SSH (22)
  - HTTP (80)
  - Jenkins (8080)
- IAM Role attached to Jenkins EC2
- Secure credential handling:
  - Docker Hub credentials
  - EC2 SSH private key

---

## 📝 Project Breakdown (Step-by-Step)

### Phase 1: Infrastructure as Code
- Terraform provisions:
  - Jenkins EC2
  - Production EC2
  - Security Groups
  - IAM Roles
- User-data installs Docker, Jenkins & dependencies

### Phase 2: Application Containerization
- Lightweight `nginx:alpine` Docker image
- Static HTML deployment
- Docker health checks enabled

### Phase 3: Blue-Green Deployment Logic
- Always deploy to **inactive environment**
- Swap traffic after successful container start
- Old container removed only after validation

### Phase 4: CI/CD Automation
- Implemented once using **GitHub Actions**
- Re-implemented using **Jenkins**
- Same logic, different CI/CD tools

---

## 🚀 How to Deploy (Quick Start)

### 1️⃣ Provision Infrastructure
```bash
terraform init
terraform apply -auto-approve
```

### 2️⃣ GitHub Actions Deployment
```bash
git commit -am "New version deployment"
git push origin main
```

### 3️⃣ Jenkins Deployment
- Open Jenkins Dashboard
- Run the pipeline job
- Monitor build stages

---

## 📊 Project Status

- [x] Terraform Infrastructure
- [x] Dockerized Application
- [x] GitHub Actions CI/CD
- [x] Jenkins CI/CD
- [x] Blue-Green Deployment
- [x] Zero Downtime Verified
- [ ] HTTPS / SSL (Future Enhancement)

---

## 💼 Why This Project Matters (Recruiter-Friendly)

✔ Demonstrates **real production DevOps skills**  
✔ Shows **tool flexibility (GitHub Actions + Jenkins)**  
✔ Uses **industry-standard practices**  
✔ Zero-downtime deployments  
✔ Infrastructure as Code  

---

## 📄 License
MIT License — free to use and modify.

---

### 📌 Next Improvements (Optional)
- Add HTTPS with ACM + Nginx
- Add Monitoring (Prometheus + Grafana)
- Add Auto Scaling Group
- Add Rollback Strategy
