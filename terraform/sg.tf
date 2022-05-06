#APP
resource "aws_security_group" "app_security_group" {
  name        = "Application-Security-Group"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.primary_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    #cidr_blocks      = [data.aws_vpc.primary_vpc.cidr_block]
    cidr_blocks     = ["0.0.0.0/0"]
  }
  
  ingress {
    description     = "Allow SSH from VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["10.0.0.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app_security_group"
  }
}

#ALB
resource "aws_security_group" "alb_security_group" {
  name        = "LoadBalancer-Security-Group"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.primary_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 8443
    to_port          = 8443
    protocol         = "tcp"
    #cidr_blocks = [data.aws_vpc.primary_vpc.cidr_block]
    #ipv6_cidr_blocks = [data.aws_vpc.primary_vpc.ipv6_cidr_block]
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "alb_security_group"
  }
}
