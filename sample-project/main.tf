provider "aws" {
    region = "us-east-1"
    access_key = ""
    secret_key = ""
}

# Sample ec2 instance
resource "aws_instance" "web-instance" {
    ami = ""
    instance_type = "t2.micro"
    tags = {
      "name" = "web-instance"
      "createdBy" = "terraform"
    }
}

# Sample vpc 
resource "aws_vpc" "web-vpc"  {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "production"
  }
}

# Smaple subnet resource within the randge of vpc and using vpc with id.
resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.web-vpc.id
    cidr_block = "10.0.0.0/24"
    tags = {
      "Name" = "prod-subnet"
    }
  
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAJTTSSUF2PB6HDCCA"
  secret_key = "ucQFWfA/Xw/xLUZKQwXFin0pxSB54N2lB8epPjLD"
}

# Sample varaibel declaration without value.
variable "subnet_prefix" {
  description = "cidr block for the subnet"

}

# Sample subnet-1 resources getting variable form file 
resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.subnet_prefix[0].cidr_block
  availability_zone = "us-east-1a"

  tags = {
    Name = var.subnet_prefix[0].name
  }
}

# Sample subnet-1 resources getting variable form file 
resource "aws_subnet" "subnet-2" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.subnet_prefix[1].cidr_block
  availability_zone = "us-east-1a"

  tags = {
    Name = var.subnet_prefix[1].name
  }
}



