# Jenkins Terraform

This is an example Terraform used to spin up Jenkins via Chef Habitat, we wrote about it on our [blog]().

## Usage

Below is an example tfvars file that could be used to spin up the infra.

```
jenkins_master_ami = "ami-a4dc46db"
jenkins_key_name = ""
jenkins_vpc_id = "<VPC ID>"
jenkins_master_subnet_id = "<Public subnet in the same VPC>"
jenkins_tag_customer = "opensource"
jenkins_tag_project = "release"
```
