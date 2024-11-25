provider "aws" {
  region = "eu-central-1"
}



resource "aws_instance" "GithubActionsInstanz" {
  count             = 2
  ami               = "ami-0eddb4a4e7d846d6f"
  instance_type     = "t2.small"
  key_name          = "terraformKey"
  vpc_security_group_ids = [aws_security_group.ssh_access.id]
  associate_public_ip_address = true  # Aktiviert öffentliche IPs für die Instanz


# Script zum Bauen und Starten des Docker-Containers
user_data = <<-EOF
  #!/bin/bash
  docker build -t nginx:latest ${var.docker_image}
  docker run -d nginx:latest
EOF


  tags = {
    Name = "Meine Github Actions Instanz ${count.index}"
  }
}

resource "aws_security_group" "ssh_access" {
  name        = "ssh_access"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH Access"
  }
}

output "instance_public_ips" {
  value = aws_instance.GithubActionsInstanz.*.public_ip
}


