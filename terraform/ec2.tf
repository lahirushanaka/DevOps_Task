

resource "aws_instance" "myinstance" {
  ami                        = data.aws_ami.project1.id
  instance_type              = var.instance_type
  iam_instance_profile       = var.iam_instance_profile
  vpc_security_group_ids     = [aws_security_group.app_security_group.id]
  subnet_id                  =  data.aws_subnets.subnet.ids[0]
  user_data                  = "${file("userdata.sh")}"
  key_name                   = var.ec2_pem_key
  associate_public_ip_address = var.public_ip

  tags = {
    Name        = "TestProject2"
    Purpose     = "project2"
    RelVersion  = "1.1"
  }
}
