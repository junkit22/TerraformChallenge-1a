### Learning Objectives:
By the end of this challenge, you should be able to:
1. Create and configure various AWS resources using Terraform, including VPCs, subnets, internet gateways, route tables, security groups, and EC2 instances.
2. Dynamically generate an EC2 key pair using Terraform and use it to connect to the instance.
3. Implement a user data script to bootstrap an EC2 instance as a web server.
4. Convert Terraform resources into reusable modules.

### Tasks:

#### Primary Tasks:
1. **Create a VPC and Networking Resources:**
   - Create a VPC with a custom name, e.g., `<your-name>-tf-vpc`, using an appropriate CIDR range (e.g., 10.0.0.0/16).
   - Create four subnets with specific CIDR ranges:
     - Public Subnet 1 in AZ1 (e.g., us-east-1a or us-east-1d).
     - Public Subnet 2 in AZ2 (e.g., us-east-1b or us-east-1e).
     - Private Subnet 1 in AZ1 (e.g., us-east-1a or us-east-1d).
     - Private Subnet 2 in AZ2 (e.g., us-east-1b or us-east-1e).
   - Create an Internet Gateway with a custom name, e.g., `<your-name>-tf-igw`.
   - Create a VPC Endpoint for S3 with a custom name, e.g., `<your-name>-tf-vpce-s3`.

2. **Configure Route Tables:**
   - Create a public route table for all public subnets with a custom name, e.g., `<your-name>-tf-public-rtb`.
   - Create two private route tables for the private subnets:
     - Private Route Table 1 for Private Subnet 1 with a custom name, e.g., `<your-name>-tf-private-rtb-az1`.
     - Private Route Table 2 for Private Subnet 2 with a custom name, e.g., `<your-name>-tf-private-rtb-az2`.

3. **Create Security Groups:**
   - Create a security group with the following ingress rules:
     - Allow HTTP from Anywhere.
     - Allow HTTPS from Anywhere.
     - Allow SSH from Anywhere.
   - Allow all egress traffic from the security group.
   - Name the security group, e.g., `<your-name>-tf-sg-allow-ssh-http-https`.

4. **Launch an EC2 Instance:**
   - Use an Amazon Linux 2023 AMI.
   - Enable a public IP for the instance.
   - Place the instance in one of the public subnets created earlier.
   - Use a previously created key pair.
   - Attach the security group created earlier.
   - Use the `t2.micro` instance type.
   - Name the instance, e.g., `<your-name>-tf-ec2`.

#### Additional Challenges:
1. **Create an EC2 Key Pair Using Terraform:**
   - Create a new EC2 key pair using Terraform.
   - Ensure the key pair is downloaded to your local machine.
   - Update your Terraform code to use this new key pair.
   - Successfully connect to your EC2 instance using the new key pair.

2. **Implement a User Data Script:**
   - Update the EC2 instance configuration to include a user data script that installs HTTPD and Docker.
   - Verify that the packages are installed after SSHing into the instance.
   - Ensure you can access the default index.html page from your browser.

3. **Convert Resources into Modules:**
   - Convert the VPC, subnets, internet gateway, route tables, security groups, and EC2 instance configurations into reusable Terraform modules.
   - Refer to the Terraform modules documentation and sample GitHub repository for guidance.

### References:
- [VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- [Route Tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)
- [Route Table Associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)
- [VPC Endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint)
- [EC2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
- [Terraform Modules](https://registry.terraform.io/namespaces/terraform-aws-modules)
- [Sample Terraform Module Code](https://github.com/luqmannnn/simple-terraform-module)

### Summary:
This assignment will enhance your skills in creating and managing AWS infrastructure using Terraform. You'll learn to create key resources, implement user data scripts for EC2 instances, and modularize your Terraform configurations for better reusability and organization.