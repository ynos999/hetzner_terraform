## Hetzner cloud create 3 nodes (master and 2 workers)
### 1. Create file terraform.tfvars and add hcloud_token = "YourToken"
### 2. Edit file "main.tf" 
####  default = "~/.ssh/id_rsa.pub"
###
### Terraform commands:
### terraform init
### terraform plan
### terraform apply

### mkdir "$env:USERPROFILE\.ssh"
### ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\id_rsa"
### public_key for Windows = file("C:/Users/YourUser/.ssh/id_rsa.pub")

### public_key for Linux is "~/.ssh/id_rsa.pub"
### Edit main.tf and replace file location:
### default = "~/.ssh/id_rsa.pub"