#!/bin/bash -x

### 1. Create a cluster with k3d that connects port 443 to the loadbalancer provided by k3d
k3d cluster create k3d-rancher --api-port 6550 --servers 1 --agents 3 --port 443:443@loadbalancer --wait
k3d cluster list

### 2. Set up a kubeconfig so you can use kubectl in your current session
KUBECONFIG_FILE=~/.kube/k3d-rancher
k3d kubeconfig get k3d-rancher > $KUBECONFIG_FILE
export KUBECONFIG=$KUBECONFIG_FILE
kubectl get nodes

### 3. Install Rancher (and its dependency cert-manager) with helm according to the docs https://rancher.com/docs/rancher/v2.x/en/installation/k8s-install/helm-rancher/
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create namespace cattle-system
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.0/cert-manager.crds.yaml
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v0.15.0 --wait
kubectl -n cert-manager rollout status deploy/cert-manager

helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.k3d.localhost --wait