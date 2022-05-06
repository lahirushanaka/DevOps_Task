
variable "data_region" {
  description = "region to launch resources"
  type        = string
  
}

variable "vpc_id" {
  description = "VPC Name"
  type        = string
  
}

variable "subnet_name" {
    description = "Subnet Name to deploy EC2"
  
}

variable "instance_type" {
    description = "instance type, ex - t3.micro"
  
}
variable "iam_instance_profile" {
    description = "IAM role that assign to EC2"  
}

variable "ec2_pem_key" {
    description = "PEM KEY for EC2"
}

variable "public_ip" {
    type = bool
    description = "Public IP required or Not"
  
}

variable "s3_bucket_state" {
    description = "S3 State file location"
  
}

