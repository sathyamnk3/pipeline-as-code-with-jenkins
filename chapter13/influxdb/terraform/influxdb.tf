data "aws_ami" "influxdb" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["influxdb-*"]
  }
}
  
resource "aws_instance" "influxdb" {
  ami                    = data.aws_ami.influxdb.id
  instance_type          = var.influxdb_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.influxdb_sg.id]
  subnet_id              = element(var.private_subnets, 0)

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = false
  }

  tags = {
    Author = var.author
    Name = "influxdb"
    Stack = "Monitoring"
  }
}