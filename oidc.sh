#!/bin/bash
echo "creating OIDC Provider"
cluster_name=my-cluster
oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
echo $oidc_id
echo "Determine whether an IAM OIDC provider with your cluster's issuer ID is already in your account"
aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4
eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve