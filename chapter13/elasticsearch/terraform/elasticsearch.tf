data "aws_ami" "elasticsearch" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["elasticsearch-*"]
  }
}
  
resource "aws_instance" "elasticsearch" {
  ami                    = data.aws_ami.elasticsearch.id
  instance_type          = var.elasticsearch_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.elasticsearch_sg.id]
  subnet_id              = element(var.private_subnets, 0)

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = false
  }

  tags = {
    Author = var.author
    Name = "elasticsearch"
    Stack = "Logging"
  }
}