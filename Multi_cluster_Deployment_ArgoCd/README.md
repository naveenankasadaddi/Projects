# 🌐 Multi-Cluster Deployments Using Argo CD

This project demonstrates how to manage and deploy containerized applications across **multiple Kubernetes clusters** using **Argo CD**. It aims to provide an automated, GitOps-based deployment pipeline for scalable, multi-environment infrastructure.

---

## 🚀 Project Overview

In modern cloud-native environments, teams often operate multiple Kubernetes clusters across regions, environments (dev, staging, prod), or cloud providers. Managing application deployments across them becomes complex without a centralized, declarative, and automated solution.

This project solves that using **Argo CD**, a GitOps continuous delivery tool for Kubernetes.

---

## 🧱 Architecture

                  ┌────────────────────┐
                  │     Git Repository │
                  └────────┬───────────┘
                           │
                     Sync via GitOps
                           │
 ┌─────────────────────────┼────────────────────────────┐
 ▼                         ▼                            ▼

┌────────────┐ ┌────────────────┐ ┌────────────────┐
│ Argo CD │ │ K8s Cluster A │ │ K8s Cluster B │
│ (Central) │ ---> │ App Deployment │ │ App Deployment │
└────────────┘ └────────────────┘ └────────────────┘


- A single **central Argo CD instance** controls deployments.
- Each Kubernetes cluster is added as a **target cluster** to Argo CD.
- Applications are defined via Helm or Kustomize and deployed based on Git state.

---

## 🧰 Tech Stack

- 🚢 **Argo CD** - GitOps continuous delivery for Kubernetes.
- ☸️ **Kubernetes** - Container orchestration platform.
- 🐙 **GitHub/GitLab** - Git repository to manage declarative application manifests.
- 📦 **Helm** or **Kustomize** - Template and manage Kubernetes manifests.
- 🌍 **Multi-cluster Kubernetes** - Multiple clusters as deployment targets.

---

## 📁 Directory Structure

.
├── clusters/
│ ├── cluster-a/
│ │ └── app-deployment.yaml
│ ├── cluster-b/
│ │ └── app-deployment.yaml
│ └── ...
├── apps/
│ ├── app1/
│ │ └── kustomization.yaml or helm/
│ └── ...
├── manifests/
│ └── argo-cd/
│ └── base/ # Argo CD install manifests
└── README.md


---

## 🔧 Prerequisites

- Kubernetes clusters (≥2) accessible via `kubectl`
- Argo CD CLI (`argocd`)
- Helm/Kustomize installed
- Git repository for configuration

---

## 📦 Setup Instructions

### 1. Install Argo CD (Central Cluster)

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f manifests/argo-cd/base/

#### 2. Access Argo CD UI
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### 3. Register Additional Clusters to Argo CD

```bash
argocd cluster add <context-name>
```

### 4. Create Argo CD Applications

```bash
kubectl apply -f clusters/cluster-a/app-deployment.yaml
kubectl apply -f clusters/cluster-b/app-deployment.yaml
```

Each app-deployment.yaml points to an app defined in the apps/ folder.

🔄 Continuous Deployment Workflow
Developer commits changes to the Git repo.

Argo CD detects changes and syncs automatically to target clusters.

Argo CD UI and CLI provide visibility and control.