provider "aws" {
  region = "ap-south-1"  # Replace with your desired AWS region
}

resource "aws_security_group" "master" {
  vpc_id = "vpc-0f28bcc0b6a596b84"

  # Port 3389 for RDP connection
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Open to all
  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    self = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # "-1" represents all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "master-key-gen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_instance" "Windows-10-Pro" {
  ami           = "ami-04fc64393c170125d"  # Replace with your desired AMI ID
  instance_type = "t3.medium"  # Replace with your desired instance type
  key_name      = aws_key_pair.master-key-pair.key_name
  subnet_id     = "subnet-0fd31cfc06b1857a4"
  availability_zone = "ap-south-1a"

  security_groups = [aws_security_group.master.id]

  tags = {
    Name = var.instance_name3
  }
}

output "exploitable_Windows" {
  value = aws_instance.Windows-10-Pro.private_ip
}

output "exploitable_Windows_Username" {
  value = "Administrator"
}

output "exploitable_Windows_Password" {
  value = "password@123"
}
