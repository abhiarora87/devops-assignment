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
![Screenshot 2023-09-24 at 1 15 52 AM](https://github.com/abhiarora87/devops-assignment/assets/54551633/d15a4c65-88c0-42cf-a234-5a4fd59b8ee0)

Terraform has been used to provision a basic ECS infrastructure hosting the docker container with basic network constructs.The endpoint URL is the DNS name of ALB port 5000 which routes the requests to the underlying docker container within the ECS service.

#### Few Important Screenshots ####
![Screenshot 2023-09-23 at 10 19 37 PM](https://github.com/abhiarora87/devops-assignment/assets/54551633/7ce9b02b-a80b-421e-998a-dbb9fc7c5c87)

![Screenshot 2023-09-23 at 10 18 47 PM](https://github.com/abhiarora87/devops-assignment/assets/54551633/a6e5c405-58ff-40d1-921a-d0bba178b508)


### Steps ###
![Screenshot 2023-09-24 at 2 05 10 AM](https://github.com/abhiarora87/devops-assignment/assets/54551633/67857f6d-1c4d-4007-b19e-ef9120feba19)

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
<img width="997" alt="Screenshot 2023-09-23 at 10 12 43 PM" src="https://github.com/abhiarora87/devops-assignment/assets/54551633/da3c7332-4969-4202-b63c-788a1e1036e7">

-> http://ALB_DNS_NAME:5000/2
<img width="1067" alt="Screenshot 2023-09-23 at 10 12 33 PM" src="https://github.com/abhiarora87/devops-assignment/assets/54551633/2a95333b-1933-4011-8ce2-903afcfaeafa">

-> http://ALB_DNS_NAME:5000/1
<img width="998" alt="Screenshot 2023-09-23 at 10 12 23 PM" src="https://github.com/abhiarora87/devops-assignment/assets/54551633/ca1599ae-c5db-4540-b99b-7656e317abe5">

-> http://ALB_DNS_NAME:5000
<img width="1338" alt="Screenshot 2023-09-23 at 10 12 09 PM" src="https://github.com/abhiarora87/devops-assignment/assets/54551633/761eb294-1072-4345-9574-0ae2b3b2cb9b">


### Improvements ###
Beyond the scope of this exercise, one potential enhancement could involve incorporating Docker vulnerability scans as a stage, along with leveraging Checkov for comprehensive security misconfiguration scanning.
### Troubleshooting & Debugging ###

While testing the docker image creation the docker daemon was crashing and got the following error on connecting to ecr repo.
```
Error response from daemon: login attempt to https://433596201564.dkr.ecr.us-east-1.amazonaws.com/v2/ failed with status: 400 Bad Request
```

In order to resolve manually removed the `"credsStore": "desktop",` from `~/.docker/config.json` from my local docker instalation.











