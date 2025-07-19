## Steps required tools:
- Use the following commands to install the required tools/applications.(for Ubuntu 20.04.6 LTS) for this projects

### Install Node.js & Express
```
  # Install Node.js (LTS version)
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
  sudo apt-get install -y nodejs

  # Install Express globally (optional, usually project-local)
  npm install -g express-generator
```

### Install Docker
```
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Post-install steps (optional)
sudo usermod -aG docker $USER
newgrp docker

# Add jenkins user to docker group.jenkins needed access to build,run a docker container
sudo usermod -aG docker jenkins

```
### Install Docker Compose
```
  DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
  mkdir -p $DOCKER_CONFIG/cli-plugins

  curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64  -o $DOCKER_CONFIG/cli-plugins/docker-compose

  chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

  # Verify
  docker compose version
```


### Install Jenkins (CI/CD Tool)
```
  # Install Java (Jenkins requires Java 11+)
  sudo apt-get install -y openjdk-17-jdk

  # Add Jenkins repository
  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

  # Install Jenkins
  sudo apt-get update
  sudo apt-get install -y jenkins

```
### Install Git & Setup GitHub
```
  sudo apt-get install -y git

  # Configure Git
  git config --global user.name "Your Name"
  git config --global user.email "your.email@example.com"

```
### Install AWS CLI v2
```
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

  sudo apt install unzip -y   # If unzip is not already installed
  unzip awscliv2.zip

  sudo ./aws/install

  # make sure to configure aws cli to create a EKS cluster in aws.with  aws_access_key_id and aws_secret_access_key.and attacha roles to create the required resources in aws like iam role,ec2 instances,vpc,subnets etc
  aws configure

```

### Install Aws eksctl
 eksctl can be used to create aws eks cluster in aws environments
```
  curl -LO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz"

  tar -xzf eksctl_Linux_amd64.tar.gz

  sudo mv eksctl /usr/local/bin/
  
  eksctl version

```