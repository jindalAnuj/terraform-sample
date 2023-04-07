### 
```
# Basic syntax
# resource "provider_<resource_type>" "name" {
#   config options........
#   key = "value"
#   key2 = "value2"
# }
```


### Install terraform.
```
brew install terraform.
```

- download terraform plugin and setup 
`terraform init`

- test all the changes 
`terraform plan`

- Apply changes to cloud
`terraform apply`
`terraform apply -target <resource>.<name>`
`terraform apply --auto-approve`



- Destroy the infra.
`terraform destroy`
`terraform destroy -target <resource>.<name>`


Note: Ordering does not matter in terraform. terraform take care of it itself.



- See terraform state only for some component.
`terraform state list`
`terraform state show <resource_id>`

- See all the resources via output.
use output here.
```
output "server_public_ip" {
    value = <resource>.<name>.public_ip
}
```


There are several ways to pass variables in Terraform:

Command-line variables: You can pass variables to Terraform from the command line using the -var option followed by the variable name and value. For example, 
`terraform apply -var="region=us-east-1"`.

Environment variables: You can set environment variables to pass variables to Terraform. The format of the environment variable is TF_VAR_name. For example, 
`export TF_VAR_region=us-east-1`.

Variable files: You can create a separate file containing all the variables and pass it to Terraform using the -var-file option. For example, 
`terraform apply -var-file="variables.tfvars"`.

Default values in the variable definition: You can define default values for variables in the Terraform code itself. For example, variable `"region" { default = "us-east-1" }`.

Input prompts: If a variable is not defined using any of the above methods, Terraform will prompt the user to enter the value for the variable during runtime.

Using these methods, you can pass variables to Terraform and make your code more reusable and customizable.



- Why connect to nic with subnet instead of ec2 itself

In AWS, a network interface (NIC) is a virtual networking component that can be attached to an EC2 instance or other AWS resources, such as an Elastic Network Interface (ENI) for an Amazon RDS database or a Lambda function.

When you create a NIC in AWS, you must associate it with a specific subnet in your VPC. This allows the NIC to be assigned a private IP address from the subnet's IP address range and enables it to communicate with other resources in the same subnet.

You can then attach the NIC to an EC2 instance, allowing the instance to use the private IP address assigned to the NIC for communication with other resources in the subnet.

By associating the NIC with the subnet instead of the EC2 instance directly, you can create more flexible and scalable networking configurations. For example, you can create a single NIC and attach it to multiple instances in the same subnet, allowing those instances to share the same network interface and IP address.

You can also move the NIC to a different instance without changing its IP address, making it easier to scale or replace instances in your VPC without disrupting the network configuration.

Overall, associating a network interface with a subnet instead of an EC2 instance directly provides greater flexibility and scalability for networking configurations in AWS.


Connections

- Vpc 
    - internet gateway
    - route table (Internet to internet gateway)
    - subnet (subset of ip addresses)
    - Route table association (subnet to route table)
    - security group
    - subnet <-> Route table association <-> route table <-> internet gateway 
    - security group,subnet,privateip <-> NIC <-> ec2
    - Elastic Ip depends on Internet gateway (PrivateIP) , associate with nic private ip <-> NIC (PrivateIP)




VPC -> Internet gateway.
Routing table decides packet flow from IG to subnet
Internet gateway connects to NIC -> subnet , security group

EC2 needs 
    network interface ( Machine to network packet routing.)
        Security group (Low level physical data centre.)
        Private Ip and subnet
        Internet gateway
            Elastic Ip.
    availability_zone. 
    security group ( port restriction )
    
   
