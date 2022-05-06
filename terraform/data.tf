data "aws_vpc" "primary_vpc" {

    tags = {
        Name          = var.vpc
        Region        = var.data_region
    }
}

# Filter Subnet to launch application primary
data "aws_subnet" "private_subnet" {

    tags = {
        Name = var.private_subnet_1
    }
}

# public subnet 1
data "aws_subnet" "public_subnet1" {

    tags = {
        Name = var.public_subnet_1
    }
}

# public subnet 2
data "aws_subnet" "public_subnet2" {

    tags = {
        Name = var.public_subnet_2
    }
}
