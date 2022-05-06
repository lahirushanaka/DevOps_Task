data "aws_ami" "project1" {
    most_recent = true
    owners      = ["137112412989"]

    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5*"]
    }  
}

data "aws_vpc" "primary_vpc" {

    id = var.vpc_id
}

# Filter Subnet to launch application primary
data "aws_subnets" "subnet" {
  tags = {
        Name = var.subnet_name

    } 
}


