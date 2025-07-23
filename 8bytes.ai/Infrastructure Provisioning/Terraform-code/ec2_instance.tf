resource "aws_instance" "app_server" {
  ami           = "ami-0c94855ba95c71c99" # Amazon Linux 2 (update with latest if needed)
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private.id
  security_groups = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "AppServer"
  }
}
