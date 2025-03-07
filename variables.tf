variable "ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-0427090fd1714168b"
}

variable "ec2_name" {
  description = "Name of EC2"
  type        = string
  default     = "junjie-tf-ec2" # Replace with your preferred EC2 Instance Name 
}

variable "instance_type" {
  description = "EC2 Instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of EC2 Key Pair"
  type        = string
  default     = "junjie-useast1-13072024" # Replace with your own key pair name (without .pem extension) that you have downloaded from AWS console previously
}

variable "sg_name" {
  description = "Name of EC2 security group"
  type        = string
  default     = "junjie-ec2-allow-ssh-http-https" # Replace with your own preferred security group name that gives an overview of the security group coverage
}

variable "vpc_name" {
  description = "Name of VPC to use"
  type        = string
  default     = "junjie-tf-vpc" # Update with your own VPC name, found under VPC > your VPC > Tags > value of Name
}

variable "subnet_name" {
  description = "Name of subnet to use"
  type        = string
  default     = "junjie-subnet-public1-us-east-1a" # Update with your own Subnet name, found under VPC > your VPC > selected Public Subnet > tags > value of Name
}