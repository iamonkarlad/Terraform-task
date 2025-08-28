provider "aws" {
  region = var.region
}

resource "aws_instance" "my-web" {
  for_each = toset(["app-server", "Db-server", "proxy-server"])
  ami = var.ami
  instance_type = var.instance-type
  key_name = var.key-name
  vpc_security_group_ids = [aws_security_group.sg-grp.id]
    tags = {
      Name = each.key
    }
}
resource "aws_security_group" "sg-grp" {
    name = "3-tier-sg"
    description = "allow SSH, HTTP, DB, PROXY"
  ingress {
    description = "allow ssh"
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
        description = "allow HTTP"
        to_port = 80
        from_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow DB-port"
        to_port = 3306
        from_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow Proxy port"
        to_port = 8080
        from_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "allow all traffic"
        to_port = 0
        from_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}
