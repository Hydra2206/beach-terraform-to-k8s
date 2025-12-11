# beach-terraform-to-k8s
Creating a project for resume and learning how to create CI/CD pipeline for automate infra provisioning with Terraform, build container, push images, automated rollout to k8s cluster, with automatic rollbacks if apply fails.

what is the overall purpose of this project?
Deploying a Django application in EKS cluster in which everything is automated from infra-provisioning to build-push-deploy. When anyone takes a PR or push the code this pipeline will run & perform all the tasks.

1/12/2025 - EKS cluster + Node group create karna sikha hu Terraform code ke through

2/12/2025 - Created ECR repo, OIDC provider manually from console, 2 IAM Roles (terraform role, deploy role)
            Created 2 workflow file for CI pipeline in Github Actions
            debugged Configure AWS Credential via OIDC (Added oidc role arn in github secrets)

(TASK FOR -> 3/12/2025)
Problem -> Terraform Plan me aake stuck hoja raha hai woh var.ami ki value expect kar raha hai, locally toh variables ki value terraform.tfvars se mil jata hai but ab yeh find out karna hai ki pipeline me variables ki               values kaise pass karte hai

Solution -> Jitne bhi variables hai tf code me un sabko AWS secrets manager me store kiya in a single secret file(JSON key-value), then iam oidc role me ek policy attach kiya joh woh secrets ko read kar paye Github                   action me jab CI pipeline run hoga tab, then terraform plan workflow me bhi changes kiya.

3/12/2025 - terraform-plan.yml workflow success bahut sare fixes karne ke baad
            ci-main.yml workflow me ek stage add kiya hu joh ki yeh ensure karega ki jab bhi terraform apply stage fail hojayega tab terraform destroy stage run hoga joh ki woh resources ko delete kar dengi joh apply ke              time pura create nahi ho payi thi
            oidc-iam-role me full Administrator access de diya yeh github action ko allow kar raha hai aws me resource create karne ke liye through oidc

(TASK FOR -> 4/12/2025) last workflow run check karna usme s3 object upload kar rahe hai woh error aara hai, usko resolve karna hai (resolved - Changed some commands to upload file in instances)

4/12/2025 - Ci-main workflow me Terraform apply job success hogya, 
            Now getting some errors in Build & deploy stage    /app - not found -? Created app folder in repo & copied Dockerfile, django file required for build process along with K8(deployment + service yaml) file.
            Getting some Kubeconfig related error (Resolved)

5/12/2025 - Getting error Unable to validate Deployment & service yaml file: failed to download openapi: Get "http://localhost:8080/openapi/v2?timeout=32s" (Bypass this issue with lots of code changes in ci-main workflow)
            ci-main workfow me bahut sare complex chije add kar diya with time while debugging aaj sab ko remove karke workflow ko ekdum simple kardiya & ci-main workflow got success run.

8/12/2025 - ci-main workflow me build-push image to ECR logic implement karra hu. Ek error tha while building image (in login to ECR stage i have used id:'ecr-login' which is wrong id should be id:'login-ecr')
            Deploy to EKS bhi successfully implement hogya hai.

11/12/2025 _**(RBAC issue - unable to see pods, deployments, services, etc in EKS cluster UI)**_
Problem -> Now unable to see pods, deployment, services in eks cluster RBAC access issue need to resolve (Resolved)

Solution -> Created a config-map & mapped my aws root account into it & applied the config-map in ci-main workflow. Now i am able to see pods, deployments, services, configmaps, etc in my aws cluster UI

12/12/2025 - Danjgo website that i have deployed through EKS cluster is working. I have accesed it through load balancer dns name. woohoo :))

Project successful !!!

Problem (Optional) - whenever terraform is trying to destroy ECR it is unable to destroy it bcoz there is an image inside ECR repo. try to find a way in which somehow 1st delete the image then repo.
            
            
            
