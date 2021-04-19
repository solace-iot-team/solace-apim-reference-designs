variable "aws_region" {
  description = "AWS Region Name"
  default = "eu-central-1"
  type=string
}

variable "ssh_key_filename" {
  description = "Path to local location of SSH_Key path+filename"
  default = "../shared/keys/aws_key_box.pub"
  type=string
}
variable "ansible_inventory_file_name" {
  description = "Path and Filename of generated Ansible inventory"
  default = "../generated/inventory"
  type=string
}

variable "boxes_file_name" {
  description = "Path and Filename of generated boxes inventory"
  default = "../generated/boxes.json"
  type=string
}

variable "generated_infrastructure_vars_file" {
  description = "Path to write Ansible var file"
  default = "../generated/ansible_infrastructure_vars.yml"
  type=string
}


variable "ssh_key_name" {
  description = "SSH keyname"
  type = string
}

variable "ami_box_1" {
  description = "AMI of the box"
  default = "ami-0e0102e3ff768559b"
  type = string
}

variable "instance_type_box_1" {
  description = "Instance type of the box (e.g. t2.small)"
  type = string
}

variable "ebs_volume_box_1_size" {
  description = "Size in GB of ebs volume attached to box1"
  type = number
}

variable "allowed_inbound_cidr_blocks" {
  description = "CIDR blocks allowed to access VPC"
  type = list(string)
}

variable "name_prefix" {
  description = "Prefix of all named resources"
  type = string
}

variable "tag_name_prefix" {
  description = "Prefix of tag NAME"
  type = string
}

variable "tag_owner" {
  description = "Tag OWNER"
  type = string
}

variable "tag_project" {
  description = "Tag PROJECT"
  type = string
}