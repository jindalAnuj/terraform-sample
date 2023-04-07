# 1. Create vpc

# A VPC is a virtual network within the AWS cloud. It allows you to create a logically 
# isolated section of the AWS cloud where you can launch resources in a virtual network 
# that you define. A VPC is a private network that you control and that is isolated from 
# other customers' VPCs and the internet.
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}

# 2. Create Internet Gateway

# An internet gateway is a device that allows communication between an 
# AWS VPC (Virtual Private Cloud) and the internet. It serves as a bridge 
# between your VPC and the internet, allowing traffic to flow between the two. 
# The internet gateway also performs NAT (Network Address Translation) to map 
# private IP addresses in your VPC to public IP addresses on the internet.
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id


}
# 3. Create Custom Route Table
# In a VPC, a route table is used to define how traffic is routed within the 
# VPC and to the internet. Each subnet in the VPC is associated with a specific 
# route table, which determines how traffic is routed to and from resources within that subnet.

# The route table contains a list of rules, or routes, that determine how traffic is directed. 
# Each route includes a destination IP address range and a target. The destination IP address 
# range specifies the range of IP addresses for which the route applies, while the target 
# specifies where the traffic should be directed.

# For example, if a route in the route table specifies a destination IP address range of 0.0.0.0/0 
# (which represents all possible IP addresses) and a target of an internet gateway, then any 
# traffic that matches that destination IP address range will be routed to the internet gateway 
# and then out to the internet.

# By configuring the route table in this way, you can control the flow of traffic within your VPC 
# and to the internet. You can create different route tables for different subnets and configure 
# them according to your specific requirements.

# Overall, the route table is a key component in managing the routing of traffic within a VPC 
# and to the internet, and it plays an important role in ensuring that resources in the VPC are 
# able to communicate effectively and securely.
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Prod"
  }
}

# 4. Create a Subnet 

# A subnet is a smaller network within a larger network. It is created by dividing a larger network 
# into smaller segments for better management and security. Subnets can be used to isolate 
# certain parts of a network and restrict access to those segments.
resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prod-subnet"
  }
}

# 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}


# 6. Create Security Group to allow port 22,80,443
# In AWS, a security group is a virtual firewall that controls inbound and outbound 
# traffic for one or more instances in a VPC (Virtual Private Cloud).

# Each security group contains a set of rules that define the type 
# of traffic allowed to access the instances associated with that security group. 
# These rules are based on a combination of the protocol (such as TCP, UDP, or ICMP), 
# port numbers, and source or destination IP addresses.

# When you launch an instance in a VPC, you can assign one or more security groups 
# to that instance. The rules in the assigned security group(s) apply to the inbound 
# and outbound traffic for that instance.
# Security groups in AWS are stateful, which means that any traffic that is 
# allowed to enter the instance is automatically allowed to leave as well. This simplifies 
# network security management, as you don't have to create separate rules for inbound and outbound traffic.

# Security groups are a key component of network security in AWS, as they provide 
# a way to control traffic at the instance level. By configuring security groups 
# to restrict access to only the necessary ports and protocols, you can help ensure 
# that your instances and data are protected from unauthorized access.

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
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
    Name = "allow_web"
  }
}

# 7. Create a network interface with an ip in the subnet that was created in step 4

# In AWS, a Network Interface (NIC) is a virtual networking component that represents 
# a network interface card. A NIC provides a virtual interface for a network connection 
# to an EC2 instance or another AWS resource.

# When you launch an EC2 instance, you can specify one or more NICs to attach to the instance. 
# Each NIC is associated with a specific subnet in a VPC and is assigned a private 
# IP address from that subnet. You can also assign one or more Elastic IP addresses to a 
# NIC to provide a static, public IP address that can be used to access the instance from the internet.

# NICs can be used to enable a variety of networking scenarios in AWS. For example, 
# you can use NICs to create multi-homed instances with connections to multiple subnets 
# or to enable network traffic monitoring and analysis with a dedicated network interface 
# for capturing traffic.

# NICs can also be used with other AWS services, such as Elastic Load Balancing (ELB) 
# and AWS Lambda. For example, when you create an ELB, you can specify one or more 
# NICs to use as the front-end interface for the load balancer.

# Overall, NICs in AWS provide a flexible and scalable way to manage networking connections 
# between EC2 instances and other AWS resources.

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}
# 8. Assign an elastic IP to the network interface created in step 7

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw]
}

output "server_public_ip" {
  value = aws_eip.one.public_ip
}

# 9. Create Ubuntu server and install/enable apache2

resource "aws_instance" "web-server-instance" {
  ami               = "ami-085925f297f89fce1"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "main-key"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF
  tags = {
    Name = "web-server"
  }
}



output "server_private_ip" {
  value = aws_instance.web-server-instance.private_ip

}

output "server_id" {
  value = aws_instance.web-server-instance.id
}
