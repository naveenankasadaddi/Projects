# Nginx Cluster Deployment on Amazon ECS

This document outlines the steps to deploy an Nginx cluster on Amazon ECS using AWS services.

## Prerequisites

* An AWS account with appropriate permissions.
* AWS CLI installed and configured.
* Basic understanding of Docker and AWS ECS.

## Deployment Steps

**Step 1: Create an ECS Cluster**

* Utilize AWS CloudFormation to provision an ECS cluster. This automated approach ensures consistent and repeatable deployments.
* The CloudFormation template should define the necessary cluster configurations, including VPC, subnets, and security groups.
* Example Cloudformation Snippet(Very basic)
    ```yaml
    Resources:
      ECSCluster:
        Type: AWS::ECS::Cluster
        Properties:
          ClusterName: NginxCluster
    ```
* Cloudformation will handle the creation of the ECS cluster.

**Step 2: Push Nginx Docker Image to Amazon ECR**

* Amazon ECS requires Docker images to be stored in Amazon ECR (Elastic Container Registry).
* Build your Nginx Docker image (if you have custom configurations) or pull the official Nginx image.
* Create an ECR repository.
* Tag and push the image to the ECR repository.

    ```bash
    # Example commands (replace with your actual repository URI)
    aws ecr create-repository --repository-name nginx-repo
    docker tag nginx:latest <your-account-id>.dkr.ecr.<your-region>[.amazonaws.com/nginx-repo:latest](https://www.google.com/search?q=https://.amazonaws.com/nginx-repo:latest)
    aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.<your-region>[.amazonaws.com](https://www.google.com/search?q=.amazonaws.com)
    docker push <your-account-id>.dkr.ecr.<your-region>[.amazonaws.com/nginx-repo:latest](https://www.google.com/search?q=https://.amazonaws.com/nginx-repo:latest)
    ```

**Step 3: Create an ECS Task Definition**

* Define a Task Definition that specifies how the Nginx container should run.
* Include the ECR image URI from Step 2.
* Configure CPU and memory limits, port mappings (typically 80 for Nginx), and other necessary settings.
* Example Task Definition JSON:
    ```json
    {
      "family": "nginx-task",
      "containerDefinitions": [
        {
          "name": "nginx-container",
          "image": "<your-account-id>.dkr.ecr.<your-region>[.amazonaws.com/nginx-repo:latest](https://www.google.com/search?q=https://.amazonaws.com/nginx-repo:latest)",
          "portMappings": [
            {
              "containerPort": 80,
              "hostPort": 80
            }
          ],
          "memory": 512,
          "cpu": 256,
          "essential": true
        }
      ],
      "networkMode": "awsvpc",
      "requiresCompatibilities": [
        "FARGATE"
      ],
      "cpu": "256",
      "memory": "512",
      "executionRoleArn": "arn:aws:iam::<your-account-id>:role/ecsTaskExecutionRole"
    }
    ```
* Ensure that the execution role has the correct permission to pull images from ECR.

**Step 4: Create an ECS Service**

* Create an ECS service within the cluster created in Step 1.
* Specify the Task Definition created in Step 3.
* Define the desired number of tasks (Nginx container instances).
* Configure a load balancer (Application Load Balancer or Network Load Balancer) to distribute traffic across the tasks.
* Ensure the security group attached to the load balancer allows incoming traffic on port 80.
* If using Fargate, ensure the service uses the awsvpc network mode.
* Provide the task family name when creating the service.

**Step 5: Access the Nginx Cluster**

* Once the ECS service is running, the Nginx containers will be accessible through the load balancer's DNS name or public IP address (if using EC2 launch type with public IPs).
* If using a load balancer, retrieve the load balancer's DNS name from the AWS console or using the AWS CLI.
* Open a web browser and navigate to the load balancer's DNS name or public IP address to view the Nginx default page.

## Notes

* For production environments, consider using AWS Fargate for serverless container execution.
* Implement auto-scaling for the ECS service to handle varying traffic loads.
* Use AWS CloudWatch for monitoring and logging.
* Ensure proper IAM roles are created and attached to the tasks and services.
* When using EC2 launch type, ensure the security groups of the EC2 instances allow incoming traffic on port 80.
* When using Fargate, ensure the security groups of the Load balancer allow incoming traffic on port 80.



***Common steps used**
```
Step-1: Create a ECS cluster withe the required informations.Cloudformation will take care of the rest of the tasks.
Step-2: ECS don't use the images from other repositories like docker registry.We need to to the images to ECR
Step-2: Create a Task definition  with required informations and use the image URI in the tasks
Step-3: Create a Service in the Cluster wit the help of task defined.Add the task family
Step-4: Once the containers are ready to use we can can access using the public ip
```


