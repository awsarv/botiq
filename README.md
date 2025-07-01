
---

# AKS + ArgoCD GitOps Automation Demo

This repository demonstrates a complete GitOps workflow using Azure Kubernetes Service (AKS), ArgoCD, and GitHub Actions.

What you can do:

* Provision an AKS cluster via Terraform
* Automatically install ArgoCD on the cluster
* Deploy a sample application using ArgoCD

## Repository Structure

* `Terraform/azure/demo/` - Terraform code for AKS and Azure networking
* `ArgoCD/demo/values.yaml` - ArgoCD Helm values (ClusterIP, admin password, etc.)
* `ArgoCD/demo/demo-app.yaml` - ArgoCD Application manifest for the sample app
* `.github/scripts/azure-login/action.yaml` - Composite GitHub Action for Azure CLI authentication
* `.github/workflows/aks-deploy.yaml` - Workflow for provisioning AKS infrastructure
* `.github/workflows/argocd-deploy.yaml` - Workflow for installing ArgoCD and deploying the sample app

## Usage Guide

### 1. Provision AKS with Terraform

* Ensure your Azure Service Principal credentials are set as repository secrets.
* Run the `.github/workflows/aks-deploy.yaml` workflow (manually or by pushing changes).
* The workflow provisions AKS and outputs kubeconfig.

### 2. Install ArgoCD and Deploy Application

* Run `.github/workflows/argocd-deploy.yaml` using the "Run workflow" button.
* Input your AKS cluster and resource group names when prompted.
* This installs ArgoCD (via public Helm), applies secure settings, and deploys a sample application with an ArgoCD Application manifest.

### 3. Access ArgoCD UI

* After deployment, use port-forwarding to access the ArgoCD UI:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

* Open [https://localhost:8080](https://localhost:8080) in your browser.
* Login as `admin`. The password is set in `ArgoCD/demo/values.yaml` (bcrypt hash).

### 4. See the Deployed Application

* The sample application (`demo-nginx` or ArgoCD Guestbook) is automatically synced by ArgoCD.
* View pods and application status in the ArgoCD UI.

## Key Features

* Complete Infrastructure as Code for reproducible AKS setup.
* Automated, secure ArgoCD installation via GitHub Actions and Helm.
* Application delivery via GitOps, managed through an Application manifest.
* No sensitive credentials are exposed; all access handled through Azure SPN and GitHub Actions.

## Customization

* To deploy a different app, edit `ArgoCD/demo/demo-app.yaml` to reference any public or private Kubernetes repo.
* To change ArgoCD settings, update `ArgoCD/demo/values.yaml`.

## Helpful Commands

```bash
# Port-forward ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Retrieve ArgoCD admin password (if using default secret)
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

# Check pods in the default namespace
kubectl get pods -n default
```

## Additional References

* ArgoCD Documentation: [https://argo-cd.readthedocs.io/](https://argo-cd.readthedocs.io/)
* ArgoCD Guestbook Example: [https://github.com/argoproj/argo-cd/tree/master/examples/guestbook](https://github.com/argoproj/argo-cd/tree/master/examples/guestbook)

---
