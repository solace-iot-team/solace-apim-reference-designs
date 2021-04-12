Default AWS-Instance (EC2) module
=================

Creates a default AWS-Instance (EC2) with 

  - NIC and public IP
  - predifined internal IP
  - assigned to a predefined security group (mandatory)
  - assigned to a predefined IAM instance profile (mandatory)

Module Input Variables
----------------------

- `name_box` - The name of the EC2 instance (box). 
- `private_ip_box` - Private IP of the box within it's subnet
-  `security_group_id` - Name of security group 
-  `subnet_id` - Id of subnet the box will reside in 
-  `ssh_key_box` - Name of SSH key 
-  `ami_box` - AMI of the box
-  `instance_type_box` - Instance type of the box (e.g. t2.small)
-  `iam_instance_profile` - IAM Instance Profile name
-  `tag_name_prefix` - Prefix of tag NAME 
-  `tag_owner` - Tag OWNER
-  `tag_project` - Tag PROJECT 

Usage 
-----
```hcl

module "mybox"{
  source = "path/to/modules/box"
  name_box = "mybox"
  private_ip_box = "10.0.0.100"
  subnet_id = aws_subnet.x.id
  security_group_id = aws_security_group.x.id
  ssh_key_box = var.ssh_key_box
  ami_box = "ami-0e0102e3ff768559b"
  instance_type_box = "t2.small"
  iam_instance_profile = aws_iam_instance_profile.x.name
  tag_name_prefix = var.tag_name_prefix
  tag_owner = var.tag_owner
  tag_project = var.tag_project
}
```

Outputs
=======
 - `public_ip` - assigned public IP address (`aws_eip.public_ip_box.public_ip`)
 - `public_dns` - assigned public DNS name (`aws_eip.public_ip_box.public_dns`)
 - `availability_zone` - Availability Zone the box resides in (`aws_instance.box.availability_zone`)
 - `box_id` - EC2 instance id (`aws_instance.box.id`)
