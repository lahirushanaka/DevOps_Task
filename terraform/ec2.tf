data "aws_ami" "project1" {
    most_recent = true
    owners      = ["137112412989"]

    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5*"]
    }  
}

resource "aws_instance" "myinstance" {
  ami                        = data.aws_ami.project1.id
  instance_type              = "t3.micro"
  count                      = 2
  iam_instance_profile       = "ProjectTestRole"
  vpc_security_group_ids     = [aws_security_group.app_security_group.id]
  subnet_id                  = "subnet-0d10e166273f59043"
  user_data                  = "${file("userdata.sh")}"
  key_name                   = "Project-Automated"
  associate_public_ip_address = true

  tags = {
    Name        = "TestProject"
    Purpose     = "project1"
    RelVersion  = "1.1"
  }
}
