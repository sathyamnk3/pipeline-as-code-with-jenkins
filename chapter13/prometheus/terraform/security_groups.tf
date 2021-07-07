resource "aws_security_group" "elb_prometheus_sg" {
  name        = "elb_prometheus_sg"
  description = "Allow https traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "elb_prometheus_sg"
    Author = var.author
  }
}

resource "aws_security_group" "prometheus_sg" {
  name        = "prometheus_sg"
  description = "Allow traffic on port 9090 and enable SSH from bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
  }

  ingress {
    from_port       = "9090"
    to_port         = "9090"
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_prometheus_sg.id]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "prometheus_sg"
    Author = var.author
  }
}

