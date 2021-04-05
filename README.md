# Deploying Flask Application 


Provision AWS resources using Terraform

```bash
1. To provision ALB
    a. Change directory to terraform/ALB and update the AWS values in terraform.tfvars and main.tf files as per the comments 
    b. Find the attached public certificate (public_rewind.dev.cert) in terraform/ALB directory 
    c. terraform init
    d. terraform plan
    e. terraform apply

2. To provision EKS
    a. Change directory to terraform/EKS and update the AWS values in terraform.tfvars and main.tf files as per the comments
    b. terraform init
    c. terraform plan
    d. terraform apply

3. To provision ECR
    a. Change directory to terraform/ECR and update the AWS values in terraform.tfvars and main.tf files as per the comments 
    b. terraform init
    c. terraform plan
    d. terraform apply

4. Provisioning CloudWatch Alarm enables application uptime monitoring, which sends notification to respective subsciber with appripriate information required.
    a. Change directory to terraform/CLOUD-WATCH 
    b. Update EMAIL and REGION to the SNS subscription
    b. terraform init
    c. terraform plan
    d. terraform apply

```


Configuring the Cluster components 

Set the EKS clsuter context using the following command
```bash
sh 'aws eks --region us-east-1 update-kubeconfig --name rewind-test-k8s'
```


To deploy the following EKS components 

```bash
1. Deploy Ambassador 
kubectl --context=rewind-test-k8s apply -f EKS-components/ambassador.yaml
2. Deploy cloud watch agent
kubectl --context=rewind-test-k8s apply -f EKS-components/cloud-watch.yaml
```


Run the Jenkins job with the below jenkinsfile to build and deploy the service into EKS

```bash
Jenkinsfile location - JENKINSFILE
    Onboard the git credentials into jenkins
    Run the JOB
```


Once jenkins job is successfull python web application will be deployed into EKS cluster as the mapping in helm/templates/mapping.yaml

Wait for few mins and access the below url from any browser
https://flask.rewind.dev/

