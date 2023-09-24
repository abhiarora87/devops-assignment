#!/bin/bash

# Define Variables

export AWS_ACCOUNT_ID="433596201564"
export AWS_ACCESS_KEY_ID=AKIAWJ5CY7JODST2XM6B
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION="us-east-1"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--profile-name) profilename="$2"; shift ;;
        -e|--ecr-path) ecrpath="$2"; shift ;;
        -r|--repo-name) repo_name="$2"; shift ;;
        -tag|--tag) tag="$2"; shift ;;
        -b|--build) build=1 ;;
        -pu|--push) push=1 ;;
        -tp|--terraform-plan) terra_plan=1 ;;
        -ta|--terraform-apply) terra_apply=1 ;;
        -td|--terraform-destroy) terra_destroy=1 ;;
        -hc|--health-check) health_check=1 ;;
        *) echo "Please pass parameters: $1"; exit 1 ;;
    esac
    shift
done


echo -e "$profilename"
echo -e "$ecrpath"

if [[ $build == 1 ]]
then
echo -e "Logging in to ECR using AWS CLI"
aws ecr get-login-password --region us-east-1 --profile "$profilename" | docker login --username AWS --password-stdin "$ecrpath"

echo -e "Building Docker Image ..."

DOCKER_DEFAULT_PLATFORM=linux/amd64 sudo docker build -t "$repo_name" -f Dockerfile .
fi

if [[ $push == 1 ]]
then
echo -e "Logging in to ECR using AWS CLI"
aws ecr get-login-password --region us-east-1 --profile "$profilename" | docker login --username AWS --password-stdin "$ecrpath"

echo -e "Tagging the image"
sudo docker tag "$repo_name":"$tag" "$ecrpath"/"$repo_name":"$tag"
echo -e "Pushing Docker image to ECR"
sudo docker push "$ecrpath"/"$repo_name":"$tag"
fi

if [[ $terra_plan == 1 ]]
then
echo -e "Running Terraform Plan"
terraform -chdir=terraform_automation init
terraform -chdir=terraform_automation plan -var-file=values.tfvars
fi

if [[ $terra_apply == 1 ]]
then
echo -e "Running Terraform Apply"
terraform -chdir=terraform_automation init
terraform -chdir=terraform_automation apply -var-file=values.tfvars -auto-approve 
fi

if [[ $terra_destroy == 1 ]]
then

echo -e "Running Terraform Destroy"

terraform -chdir=terraform_automation init
terraform -chdir=terraform_automation destroy -var-file=values.tfvars -auto-approve
fi

if [[ $health_check == 1 ]]
then
echo -e "Checking the Health Check of the ALB DNS "

HEALTH_CHK=$(aws elbv2 describe-load-balancers --profile devops-user --names ecs-alb --query 'LoadBalancers[0].DNSName' --output text)

URL="http://$HEALTH_CHK:5000"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)

# Check if the HTTP status code is 200
if [ "$HTTP_STATUS" -eq "200" ]; then
  echo "DNS is healthy. Status code: $HTTP_STATUS"
else
  echo "DNS is not healthy. Status code: $HTTP_STATUS"
fi


fi
