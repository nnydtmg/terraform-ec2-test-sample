# ---------------------------
# プロバイダ設定
# ---------------------------
# AWS
provider "aws" {
  region     = "ap-northeast-1"
}

# ---------------------------
# VPC
# ---------------------------
resource "aws_vpc" "vpc"{
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-vpc"
  }
}

# ---------------------------
# Subnet
# ---------------------------
resource "aws_subnet" "public_1a_sn" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.az_a}"

  tags = {
    Name = "terraform-public-1a-sn"
  }
}


# ---------------------------
# Security Group
# ---------------------------
# # 自分のパブリックIP取得
# data "http" "ifconfig" {
#   url = "http://ipv4.icanhazip.com/"
# }

# variable "allowed_cidr" {
#   default = null
# }

# locals {
#   myip          = chomp(data.http.ifconfig.body)
#   allowed_cidr  = (var.allowed_cidr == null) ? "${local.myip}/32" : var.allowed_cidr
# }

# Security Group作成
resource "aws_security_group" "ec2_sg" {
  name              = "terraform-ec2-sg"
  description       = "For EC2 Linux"
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "terraform-ec2-sg"
  }

  # インバウンドルール
  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = [local.allowed_cidr]
  # }

  # アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# ---------------------------
# EC2
# ---------------------------
# Amazon Linux 2 の最新版AMIを取得
data "aws_ssm_parameter" "amzn2_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# EC2作成
resource "aws_instance" "ec2"{
  ami                         = data.aws_ssm_parameter.amzn2_latest_ami.value
  instance_type               = "t2.micro"
  availability_zone           = "${var.az_a}"
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  subnet_id                   = aws_subnet.public_1a_sn.id
  associate_public_ip_address = "true"
  tags = {
    Name = "terraform-ec2"
  }
}