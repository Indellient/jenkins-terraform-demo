
////////////////////////////////
// AWS Connection

variable "aws_profile" {
  default = "bluepipeline"
}

variable "aws_region" {
  default = "us-east-1"
}

////////////////////////////////
// Server Settings

variable "aws_centos_image_user" {
  default = "centos"
}

////////////////////////////////
// Tags

variable "jenkins_tag_customer" { }

variable "jenkins_tag_project" { }


variable "tag_name" {
  default = "Jenkins"
}

variable "tag_dept" {
  default = "bluepipeline"
}

variable "tag_contact" {
  default = "admins@bluepipeline.io"
}

variable "tag_application" {
  default = "Jenkins"
}

variable "tag_ttl" {
  default = 3600
}

variable "aws_key_pair_file" {
  default = "~/.ssh/bluepipeline.pem"
}

variable "jenkins_master_ami" { }

variable "jenkins_key_name" { }

variable "jenkins_master_instance_type" {
  default = "m4.large"
}

variable "jenkins_vpc_id" { }

variable "jenkins_master_subnet_id" { }

variable "jenkins_admin_username" {
  default = "admin"
}

variable "jenkins_admin_password" {
  default = "admin"
}

////////////////////////////////
// Habitat

variable "origin" {
  default = "skylerto"
}

variable "channel" {
  default = "stable"
}
