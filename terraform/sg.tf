#APP
resource "aws_security_group" "app_security_group" {
  name        = "Application-Security-Group2"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.primary_vpc.id

    
  ingress {
    description     = "Allow SSH from VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Application Port"
    from_port       = 10000
    to_port         = 10000
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app_security_group2"
  }
}

