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