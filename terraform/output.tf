output "APP_IP" {
  value = "${aws_instance.myinstance.public_ip}:10000"
}