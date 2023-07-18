provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "vpc-sq" {
    cidr_block = "10.0.0.0/16"
    tags = { Name = "vpc-sq" }
}

resource "aws_internet_gateway" "nginx-igw" {
    vpc_id = aws_vpc.vpc-sq.id
    tags = { Name = "nginx-igw" }
}

resource "aws_subnet" "subnet-sq" {
  vpc_id     = aws_vpc.vpc-sq.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "subnet-sq" }
}

resource "aws_route_table" "rt-sq" {
  vpc_id = aws_vpc.vpc-sq.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nginx-igw.id
  }
  tags = { Name = "rt-sq" }
}

resource "aws_route_table_association" "nginx1-rt-association" {
  subnet_id      = aws_subnet.subnet-sq.id
  route_table_id = aws_route_table.rt-sq.id
}

resource "aws_security_group" "sg-sq" {
  vpc_id      = aws_vpc.vpc-sq.id

ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTPS connections"
  }
ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }
egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = { Name = "sg-sq" }
}

/*
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
*/

resource "aws_instance" "nginx" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.small"
  subnet_id                   = aws_subnet.subnet-sq.id
  vpc_security_group_ids      = [aws_security_group.sg-sq.id]
  associate_public_ip_address = true
  key_name = "win11-key"

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > nginx-pub-ip.txt"
  }

  tags = { Name = "sonarqube" }
  }