terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


#Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  # Edit below
  #access_key = "my-access-key"
  #secret_key = "my-secret-key"
}

# Create AWS S3
resource "aws_s3_bucket" "bucket" {
  #Change to unique name
  bucket ="junjie-s3-tf-29072024"

  tags = {
    Name = "junjie bucket"
    Environment = "Dev"
    Department = "DevOps"
  }
}

#Create VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "junjie-tf-vpc"
  }
}

# Define Public Subnet 1 in AZ1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "junjie-tf-public-subnet-az1"
  }
}

# Define Public Subnet 2 in AZ2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "junjie-tf-public-subnet-az2"
  }
}

# Define Private Subnet 1 in AZ1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "junjie-tf-private-subnet-az1"
  }
}

# Define Private Subnet 2 in AZ2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "junjie-tf-private-subnet-az2"
  }
}

# Define internet gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "junjie-tf-igw"
  }
}

# Define VPC Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.s3"

  tags = {
    Environment = "junjie-tf-vpce-s3"
    Name = "junjie-tf-vpc-vpce-3"
  }
}

# Define a route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "junjie-tf-public-rtb"
  }
}

# Associate the public subnet 1 with the public route table
resource "aws_route_table_association" "public_subnet_az1_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public.id
}

# Associate the public subnet 2 with the public route table
resource "aws_route_table_association" "public_subnet_az2_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public.id
}

# Define a route table for private subnet az1
resource "aws_route_table" "private_az1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "junjie-tf-private-rtb-az1"
  }
}

# Associate the private subnet 1 with the private route table
resource "aws_route_table_association" "private_subnet_az1_association" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_az1.id
}

# Define a route table for private subnet az2
resource "aws_route_table" "private_az2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "junjie-tf-private-rtb-az2"
  }
}


# Associate the private subnet 2 with the private route table
resource "aws_route_table_association" "private_subnet_az2_association" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_az2.id
}

# Define a security group
resource "aws_security_group" "allow_ssh_http_https" {
  name        = "junjie-tf-sg-allow-ssh-http-https"
  description = "Security Group to allow SSH, HTTP, and HTTPS traffic"
  vpc_id      = aws_vpc.main.id

  # Ingress rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  # Egress rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

## Additional Challenge 1 - Create Key Pair and download to local file
# Create EC2 Key Pair
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "generated_key" {
  key_name   = "junjie1-tf-key"
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "${path.module}/junjie1-tf-key.pem"
  provisioner "local-exec" {
    command = "chmod 400 ${path.module}/junjie1-tf-key.pem"
  }
}


# Define the EC2 instance
resource "aws_instance" "example" {
  ami             = "ami-0427090fd1714168b" # Amazon Linux 2023 AMI ID
  instance_type   = "t2.micro"
  #key_name       = "junjie-useast1-13072024"
  key_name         = aws_key_pair.generated_key.key_name # Part of additional challenge 1
  subnet_id        = aws_subnet.public_subnet_az1.id
  security_groups  = [aws_security_group.allow_ssh_http_https.id] # Use the security group
  associate_public_ip_address = true # Enable public IP


 ## Additional Challenge 2 - Create EC2 with a User Data script / bootstrap script
  # Define the user data script
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    yum install docker -y
    systemctl start httpd
    systemctl enable httpd
    usermod -a -G apache ec2-user
    chown -R ec2-user:apache /var/www
    chmod 2775 /var/www
    find /var/www -type d -exec chmod 2775 {} \;
    find /var/www -type f -exec chmod 0664 {} \;
    echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
  EOF


  tags = {
    Name = "junjie-tf-ec2"
  }
}

