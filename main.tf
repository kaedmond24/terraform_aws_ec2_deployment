# configure aws provider
provider "aws" {
  # Add access key and secret to run terraform apply
  access_key = "Enter Access Key"
  secret_key = "Enter Secret Key"
  region = "us-east-1"
  #profile = "Admin"
}

# create instance
resource "aws_instance" "web_server02" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_ssh.id]
  key_name = "Enter Key Pair Name"
  subnet_id = "Enter Subnet ID"
  associate_public_ip_address = "true"

  user_data = "${file("jenkins_setup.sh")}"

  tags = {
    "Name" : "tf_kura_instance"
    "vpc" : "kura-vpc"
  }

}

# create security groups

resource "aws_security_group" "web_ssh" {
  vpc_id = "Enter VPC ID"
  name        = "tf_kura_sg"
  description = "open ssh traffic"


  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : "tf_made_sg"
    "Terraform" : "true"
  }

}

output "instance_ip" {
  value = aws_instance.web_server02.public_ip
}
