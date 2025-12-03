resource "aws_s3_bucket" "mittu-bkt" {
  bucket = var.s3_bucket

  tags = {
    Name = "mittu-bkt"
  }
}

resource "aws_s3_object" "photo-1" {
  bucket = aws_s3_bucket.mittu-bkt.bucket
  key    = "photos/beach.png"
  source = "D:/beach-terraform-to-k8s/terraform/beach.png"
}

resource "aws_s3_object" "photo-2" {
  bucket = aws_s3_bucket.mittu-bkt.bucket
  key    = "photos/bitch.png"
  source = "D:beach-terraform-to-k8s/terraform/bitch.png"
}

#created for public access
resource "aws_s3_bucket_public_access_block" "pen" {
  bucket = aws_s3_bucket.mittu-bkt.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#creating Iam role for ec2 with s3 full access
resource "aws_iam_policy" "s3-full-access" {
  name = "s3-full-access-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:*"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role" "ec2-role" {
  name = "ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"           #Here, it means EC2 instances are trusted to assume this role.
    }]
  })
}

resource "aws_iam_role_policy_attachment" "example_attach" { #yaha pe role & policy ko attach kiye
  role       = aws_iam_role.ec2-role.name
  policy_arn = aws_iam_policy.s3-full-access.arn
}

resource "aws_iam_instance_profile" "ec2-profile" {                   #instance profile ko role ke sath attach kar diye abb yeh instance profile ke sath ec2 create hoga
  name = "instance-profile"
  role = aws_iam_role.ec2-role.name
}