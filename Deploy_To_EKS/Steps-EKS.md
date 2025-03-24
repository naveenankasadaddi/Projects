# EKS Cluster Setup and ALB Controller Deployment

This document outlines the steps to create an Amazon Elastic Kubernetes Service (EKS) cluster, deploy an application, and configure an Application Load Balancer (ALB) controller.

## Prerequisites

* `eksctl`
* `kubectl`
* `aws cli`
* `helm`

## Steps

**Step 1: Create an EKS cluster**

Create an EKS cluster using `eksctl`. Replace `<cluster-name>` and `<region>` with your desired values.

```bash
eksctl create cluster --name <cluster-name> --region <region>
# Example:
eksctl create cluster --name Cluster-demo --region us-east-1
```
**Step 2: (Optional) General Cluster Configuration**
```

Configure general cluster settings as needed.

Authentication: Attach identifiers if required.
Bash

# (Example: replace with your specific authentication commands)
# ...
Fargate Profiles: Create custom Fargate profiles.
Bash

# (Example: replace with your specific Fargate profile creation)
# eksctl create fargateprofile --cluster <cluster-name> --region <region> --name <profile-name> --namespace <namespace-name>
Logging: Enable logging for monitoring.
Bash

# (Example: replace with your specific logging configuration)
# ...
```

**Step 3: Update kubeconfig**
```
Update your kubeconfig file to interact with the cluster.

Bash

aws eks update-kubeconfig --name <cluster-name> --region <region>
# Example:
aws eks update-kubeconfig --name Cluster-demo --region us-east-1
```
**Step 4: Create a Fargate Profile (Optional)**
```
Create a separate Fargate profile if needed.

Bash

eksctl create fargateprofile --cluster <cluster-name> --region <region> --name <profile-name> --namespace <namespace-name>
# Example:
eksctl create fargateprofile --cluster Cluster-demo --region us-east-1 --name alb-sample-app --namespace game-2048
```
**Step 5: Deploy the Application**
```
Deploy the application to the EKS cluster.

Bash

kubectl apply -f [https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/examples/2048/2048_full.yaml](https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/examples/2048/2048_full.yaml)
```
**Step 6: Associate an IAM OIDC Provider**
```
Associate an IAM OIDC provider with the cluster.

Bash

eksctl utils associate-iam-oidc-provider --cluster <cluster-name> --approve
# Example:
cluster_name="Cluster-demo"
eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve
```
***Step 7: Create an ALB Controller IAM Role**
```

Download the IAM policy.

Bash

curl -O [https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json](https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json)
Create the IAM policy.

Bash

aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json
Create the IAM role.

Bash

eksctl create iamserviceaccount --cluster Cluster-demo --namespace kube-system --name aws-load-balancer-controller --role-name AmazonEKSLoadBalancerControllerRole --attach-policy-arn arn:aws:iam::<your-account-id>:policy/AWSLoadBalancerControllerIAMPolicy --approve
Replace <your-account-id> with your AWS Account ID.
```

**Step 8: Deploy the ALB Controller using Helm**
```
Add the Helm repository.

Bash

helm repo add eks [https://aws.github.io/eks-charts](https://aws.github.io/eks-charts)
Update Helm repositories.

Bash

helm repo update eks
Install the Helm chart.

Bash

helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=Cluster-demo --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller --set region=us-east-1 --set vpcId=vpc-0d2b70a1555471208
Replace vpc-0d2b70a1555471208 with your VPC ID.

Verify the deployment.

Bash

kubectl get deployment -n kube-system aws-load-balancer-controller
Troubleshooting: If the ALB controller pods fail to create, delete the CloudFormation stack and the Helm chart.

Bash

helm delete aws-load-balancer-controller -n kube-system
Get the Ingress address.

Bash

kubectl get ingress -n game-2048
This command will display the ALB address.
```





