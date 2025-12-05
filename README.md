# beach-terraform-to-k8s
Creating a project for resume &amp; learning how to create CI/CD pipeline for Terraform code, k8s, docker &amp; learning

1/12/2025 - EKS cluster + Node group create karna sikha hu Terraform code ke through

2/12/2025 - Created ECR repo, OIDC provider manually from console, 2 IAM Roles (terraform role, deploy role)
            Created 2 workflow file for CI pipeline in Github Actions
            debugged Configure AWS Credential via OIDC (Added oidc role arn in github secrets)

(TASK FOR -> 3/12/2025)
Problem -> Terraform Plan me aake stuck hoja raha hai woh var.ami ki value expect kar raha hai, locally toh variables ki value terraform.tfvars se mil jata hai but ab yeh find out karna hai ki pipeline me variables ki values kaise pass karte hai

Solution -> Jitne bhi variables hai tf code me un sabko AWS secrets manager me store kiya in a single secret file(JSON key-vaue), then iam oidc role me ek policy attach kiya joh woh secrets ko read kar paye Github action me jab CI pipeline run hoga tab, then terraform plan workflow me bhi changes kiya.

3/12/2025 - terraform-plan.yml workflow success bahut sare fixes karne ke baad
            ci-main.yml workflow me ek stage add kiya hu joh ki yeh ensure karega ki jab bhi terraform apply stage fail hojayega tab terraform destroy stage run hoga joh ki woh resources ko delete kar dengi joh apply ke time pura create nahi ho payi thi
            oidc-iam-role me full Administrator access de diya yeh github action ko allow kar raha hai aws me resource create karne ke liye through oidc

(TASK FOR -> 4/12/2025) last workflow run check karna usme s3 object upload kar rahe hai woh error aara hai, usko resolve karna hai (resolved - Changed some commands to upload file in instances)

4/12/2025 - Ci-main workflow me Terraform apply job success hogya, 
            Now getting some errors in Build & deploy stage    /app - not found -? Created app folder in repo & copied Dockerfile, django file required for build process along with K8(deployment + service yaml) file.
            Getting some Kubeconfig related error (Resolved)

5/12/2025 - Getting error Unable to validate Deployment & service yaml file: failed to download openapi: Get "http://localhost:8080/openapi/v2?timeout=32s" (Bypass this issue with lots of code changes in ci-main workflow)
            ci-main workfow me bahut sare complex chije add kar diya with time while debugging aaj sab ko remove karke workflow ko ekdum simple kardiya & ci-main workflow got success run.

(TASK FOR -> 6/12/2025) ci-main workflow toh success hogya but ouput me kya milega usko pata lagana hai, koi app run hoga website. what is the overall purpose of this project?
                        maybe 2-3 workflow create hua in this project line-by-line pura workflow samajhna hai & terraform code me bhi bahut sare chij new resource add kiya use bhi review karna hai
            
            
            
