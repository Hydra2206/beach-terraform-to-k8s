#This is for remote backend setup
terraform {
  backend "s3" {
    bucket = "remote-backend-statefile-bucket" #one thing to remember here we have to manually create a s3 bkt for Remote backend then it will use the bkt
    key    = "remote_backend/terraform.tfstate"
    region = "ap-south-1"
    #use_lockfile = true
  }
}