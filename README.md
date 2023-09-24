## The ask ##

* To containerize the Flask API 
* To build Infra to deploy the app using ECS using Terraform
* Create a bash script for deployment to AWS (build and push to ECR) with a health check
* Provide a simplified playbook (with arch diagram), demonstrating the things delivered 

## Deliverables ##

### Overview ###

In this exercise we are containerizing an application using Dockerfile with python API. The cloud provider being used in AWS and bash script is created to simulate various stages for deploying the containerized application in AWS Cloud.

### Tools & Techniques ###
* Git
* Terraform
* docker
* AWS CLI
* bash script

### Prerequisites ###
* AWS Account Setup (Free Tier)
* Installing Docker, terraform
* AWS CLI 
* IDE (VSCode)

### AWS Architecture ###
![Architecture Diagram](/images/architecture_diagram.png)

Terraform has been used to provision a basic ECS infrastructure hosting the docker container with basic network constructs. The endpoint URL is the DNS name of ALB port 5000 which routes the requests to the underlying docker container within the ECS service.

#### Few Important Screenshots ####
![ALB](/images/ALB.png)

![ecs-cluster](/images/ecs-cluster.png)


### Steps ###
![Steps](/images/steps.png)

* First, we provision the ECR repository with appropiate policy attached using Terraform
```
terraform init
terraform plan -var-file=values.tfvars
terraform apply -var-file=values.tfvars -auto-approve
```
* After creating the ECR repo, the Docker image is built, tagged, and pushed using a bash script.
```
sudo bash script.sh -p devops-user -e 433596201564.dkr.ecr.us-east-1.amazonaws.com -r pythonapi -tag latest -b -pu
```    
where 
```
-p = profile name 
-e = ecr repo path = this was created as part of step 1
-r = ecr repo name = this was created as part of step 1
-tag = tag/version 
-b = build the image
-pu = push the image
```

* After successfully uploading the Docker image to the ECR repository, we execute Terraform commands to provision the ECS infrastructure to run container along with the necessary underlying network constructs.
```
sudo bash script.sh -p devops-user -e 433596201564.dkr.ecr.us-east-1.amazonaws.com -r pythonapi -tag latest -tp -ta
```
where
```
-tp = terraform plan
-ta = terraform apply
```

* Finally, after provisioning the ECS infrastructure and ensuring the container is operational, a health check is conducted on the URL endpoint to verify a 200 status code, indicating a healthy status.
```
sudo bash script.sh -p devops-user -e 433596201564.dkr.ecr.us-east-1.amazonaws.com -r pythonapi -tag latest -hc
```
where
-hc = health check

It can also we verified for the browser with following parameters


-> http://ALB_DNS_NAME:5000/3
![DNS:3](/images/DNS:3.png)

-> http://ALB_DNS_NAME:5000/2
![DNS:2](/images/DNS:2.png)

-> http://ALB_DNS_NAME:5000/1
![DNS:1](/images/DNS:1.png)

-> http://ALB_DNS_NAME:5000
![DNS](/images/DNS.png)


### Improvements ###
Beyond the scope of this exercise, one potential enhancement could involve incorporating Docker vulnerability scans as a stage, along with leveraging Checkov for comprehensive security misconfiguration scanning.
### Troubleshooting & Debugging ###

While testing the docker image creation the docker daemon was crashing and got the following error on connecting to ecr repo.
```
Error response from daemon: login attempt to https://433596201564.dkr.ecr.us-east-1.amazonaws.com/v2/ failed with status: 400 Bad Request
```

In order to resolve manually removed the `"credsStore": "desktop",` from `~/.docker/config.json` from my local docker instalation.











