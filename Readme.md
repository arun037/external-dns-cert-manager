# External-DNS

### Step 1: Create oidc connect 
 ```bash
    chmod +x oidc.sh
   ./oidc.sh
   ```

### Step 2: 

 ```bash
   aws iam create-policy --policy-name "AllowExternalDNSUpdates" --policy-document file://policy.json
   ```
### Step 3: 

 ```bash
   export cluster_name=my-cluster
   export role_name=AmazonExternal_DNS_Role

   ```
# Create the IAM service account

 ```bash
  eksctl create iamserviceaccount \
    --name external-dns-sa \
    --namespace kube-system \
    --cluster $cluster_name \
    --role-name $role_name \
    --role-only \
    --attach-policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess \
    --approve

   ```
# Fetch and modify the trust policy
 ```bash
   TRUST_POLICY=$(aws iam get-role --role-name $role_name --query 'Role.AssumeRolePolicyDocument' | \
    sed -e 's/kube-system:external-dns-sa/kube-system:external-dns-*/' -e 's/StringEquals/StringLike/')

   ```
 # Update the role with the modified trust policy
 ```bash
aws iam update-assume-role-policy --role-name $role_name --policy-document "$TRUST_POLICY"
 ```
# Step 4:  Create Service account

```bash
eksctl create iamserviceaccount --name <SERVICE_ACCOUNT_NAME> --namespace kube-system --cluster CLUSTER_NAME --attach-policy-arn <IAM_POLICY_ARN> --approve --region < >
   ```
change the service_account_name, cluster_name, IAM_POLICY_ARN & region

 ```bash
  kubectl api-versions | grep rbac.authorization.k8s.io
 ```

### Step 5: 

```bash
  kubectl create -f clusterrole.yaml
  kubectl create -f clusterrolebinding.yaml

   ```
then apply kubectl apply -f external-dns.yaml
(change txt-owner-id as zone id, domain-filter as domain and aws-zone-type as public)

```bash
  kubectl create -f external-dns.yaml 
   ```

### Step 6: 

```bash
 Kubectl apply -f deploy.yaml
 Kubectl apply -f deploy2.yaml 
   ```

### Step 7:

install nginx-ingress using helm

```bash
 helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
 helm repo update
 helm install ingress-nginx ingress-nginx/ingress-nginx
   ```

### Step 8:

```bash
 kubectl apply -f ingress.yaml
   ```

```bash
kubectl logs external-dns-9f85d8d5b-sx5fg -n kube-system
 ```

                                                        #THANK_YOU