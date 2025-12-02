# second-terraform-project
yeh project me ka task hai

s3 bucket me objects hai mujhe s3 bkt se objects lana hai ec2 server ke help se aur usko webpage pe show karna hai
2 ec2 server hai jinke help se yeh webpage chalega, iske aage ek ALB use kar raha hu
ec2 & s3 ke beech me ek IAM role assign kiya hu ec2 ko joh ki ec2 instance ko yeh allow kar raha hai ki jaa s3 se yeh object leke aaja

Challenges:-
1. Image load nahi hora tha jab bhi public ip se search karra tha (Html me img src ka issue tha)
2. whenever I'm accessing my app with load balancer dns name, image is not loading (404 Not Found) but accessing with ec2 public ip's image is getting loaded (Not resolved)

Next Task:-
25/11/2025- Added modules in the code, workspaces, setup remote backends using s3 bkt in ap-south-2 region (Done)
