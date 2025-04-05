#!/bin/bash


set -e

echo "🔍 Checking Metrics Server..."
if kubectl get deployment metrics-server -n kube-system > /dev/null 2>&1; then
  echo "✅ Metrics Server is already installed."
else
  echo "📦 Installing Metrics Server..."
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
fi

echo ""
echo "🔍 Checking AWS EBS CSI Driver..."
if kubectl get daemonset ebs-csi-node -n kube-system > /dev/null 2>&1; then
  echo "✅ AWS EBS CSI Driver is already installed."
else
  echo "📦 Installing AWS EBS CSI Driver..."
  kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.41"
fi


echo "Creating Storage Classes"
kubectl apply -f ../volumes
