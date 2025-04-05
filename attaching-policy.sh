#!/bin/bash

EBS_CSI_POLICY_ARN="arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
ECR_POLICY_ARN="arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"

echo "🔍 Searching for NodeInstanceRole..."
NODE_ROLE=$(aws iam list-roles \
  --query "Roles[?contains(RoleName, 'NodeInstanceRole') && contains(RoleName, 'eksctl')].RoleName" \
  --output text | head -n 1)

if [ -z "$NODE_ROLE" ] || [ "$NODE_ROLE" == "None" ]; then
    echo "❌ No matching Node IAM Role found. Exiting."
    exit 1
else
    echo "✅ Node Role found: $NODE_ROLE"
    echo "📎 Attaching required policies..."
    aws iam attach-role-policy --role-name "$NODE_ROLE" --policy-arn "$EBS_CSI_POLICY_ARN"
    aws iam attach-role-policy --role-name "$NODE_ROLE" --policy-arn "$ECR_POLICY_ARN"
    echo "🎉 Policies attached successfully to: $NODE_ROLE"
fi
