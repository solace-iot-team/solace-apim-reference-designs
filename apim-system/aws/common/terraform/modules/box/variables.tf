variable "name_box" {
  description = "name of the box"
  default = "box"
  type = string
}

variable "private_ip_box" {
  description = "private IP address of the box"
  type = string
}

variable "security_group_id" {
  description = "name of the security group this box belongs to"
  type = string
}

variable "subnet_id" {
  description = "id of subnet this box will get assigned to"
  type = string
}

variable "ssh_key_box" {
  description = "SSH keyname"
  type = string
}

variable "ami_box" {
  description = "AMI of the box"
  type = string
}

variable "instance_type_box" {
  description = "Instance type of the box (e.g. t2.small)"
  type = string
}

variable "iam_instance_profile" {
  description = "IAM-Instance-Profile name"
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