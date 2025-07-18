# CI/CD Pipeline for Express.js Application

## Overview

This project implements a **CI/CD pipeline** to build, containerize, and deploy a simple **Express.js "Hello World" application**.  
The pipeline automates:

- Code checkout from Git
- Docker image build and push to a container registry (e.g., Docker Hub, AWS ECR)
- Deployment to a container runtime (e.g., Docker, Kubernetes, AWS ECS/EKS)

---

## **Project Structure**
```
express-hello-world/
├── index.js # Express app entry point
├── package.json # Node.js dependencies
├── Dockerfile # Docker image build instructions
├── .dockerignore # Files to ignore during Docker build
└── README.md # Project documentation
```

---

## **CI/CD Pipeline Stages**

### 1️⃣ **Build**

- Pull the latest code from the repository.
- Install Node.js dependencies (`npm install`).
- Run linter/test steps (optional).

### 2️⃣ **Dockerize**

- Build a Docker image using the `Dockerfile`.
- Tag the image as `express-hello-world:<version>`.

### 3️⃣ **Push**

- Push the Docker image to your registry (e.g., Docker Hub / AWS ECR).

### 4️⃣ **Deploy**

- Deploy the container to your target environment:
  - Local Docker engine
  - Kubernetes (EKS, Minikube, etc.)
  - AWS ECS / Fargate
  - On-prem servers

---

## **Technologies Used**

- **Node.js & Express** – Backend application
- **Docker** – Containerization
- **CI/CD Tool** – *Jenkins* / *GitLab CI* / *GitHub Actions* (Specify your choice)
- **Container Registry** – Docker Hub / AWS ECR / Other (Customize)
- **Kubernetes / Docker Compose** – (Optional deployment environment)

---

## **How to Run Locally**

### **Without Docker**

```bash
npm install
node index.js
