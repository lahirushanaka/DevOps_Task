# Consul backend is used here. Also Terraform workspaces are used. 
terraform {
  backend "s3" {
    encrypt  = true
  }
}
