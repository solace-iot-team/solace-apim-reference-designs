terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}

data "local_file" "boxkey" {
  filename = var.ssh_key_filename
}

resource "aws_key_pair" "key_deployer" {
  key_name   = var.ssh_key_name
  public_key = data.local_file.boxkey.content
}

resource "aws_iam_role" "cw_role" {
  name = "${var.name_prefix}_cloudwatch_publisher"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "async-api-cloudwatch-publishing"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "logs:CreateLogStream","logs:PutLogEvents"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
  })
 }

}

resource "aws_iam_instance_profile" "cw_instance_profile" {
  name = "${var.name_prefix}_cloudwatch_publisher_profile"
  role = aws_iam_role.cw_role.name
}

resource "aws_cloudwatch_log_group" "async-api-platform" {
  name = "${var.name_prefix}-group"
   tags = {
    Name = "${var.tag_name_prefix}-vpc"
    Owner = var.tag_owner
    Project = var.tag_project
  }
}
resource "aws_vpc" "vpc" {

  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.tag_name_prefix}-vpc"
    Owner = var.tag_owner
    Project = var.tag_project
  }
}



resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_name_prefix}-gateway"
    Owner = var.tag_owner
    Project = var.tag_project
  }
}


resource "aws_subnet" "dmz" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-subnet-dmz"
    Owner = var.tag_owner
    Project = var.tag_project
  }
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.vpc.id
    route   {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gateway.id
    }
    

    tags = {
        Name = "${var.tag_name_prefix}-route-table"
        Owner = var.tag_owner
        Project = var.tag_project
  }
}

resource "aws_route_table_association" "rt" {
     subnet_id = aws_subnet.dmz.id
     route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg_dmz" {
    name = "${var.name_prefix}_sg_dmz"
    vpc_id = aws_vpc.vpc.id

    ingress = [ {
      cidr_blocks = var.allowed_inbound_cidr_blocks
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      description = "ICMP PINGs"
      self = true
      from_port = 1
      protocol = "icmp"
      to_port = 1
     },{
      cidr_blocks = var.allowed_inbound_ssh_cidr_blocks
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      description = "ssh inbound"
      self = true
      from_port = 22
      protocol = "tcp"
      to_port = 22
     }, {
      cidr_blocks = var.allowed_inbound_cidr_blocks
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      description = "http traffic for portal"
      self = true
      from_port = 80
      protocol = "tcp"
      to_port = 80
     }, {
      cidr_blocks = var.allowed_inbound_cidr_blocks
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      description = "http traffic for platform-api"
      self = true
      from_port = 3000
      protocol = "tcp"
      to_port = 3000
     },{
      cidr_blocks = var.allowed_inbound_administration_cidr_blocks
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      description = "mysql traffic for administration only"
      self = true
      from_port = 3306
      protocol = "tcp"
      to_port = 3306
    }
    ]

    egress = [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      description = "all outbound"
      from_port = 0
      protocol = "-1"
      self = true
      to_port = 0
    } ]

    tags = {
        Name = "${var.tag_name_prefix}-sg-dmz"
        Owner = var.tag_owner
        Project = var.tag_project
  }
}

module "box1"{
  source = "../../common/terraform/modules/box"
  name_box = "box1"
  private_ip_box = "10.0.0.100"
  subnet_id = aws_subnet.dmz.id
  security_group_id = aws_security_group.sg_dmz.id
  ssh_key_box = var.ssh_key_name
  ami_box = var.ami_box_1
  instance_type_box = var.instance_type_box_1
  iam_instance_profile = aws_iam_instance_profile.cw_instance_profile.name
  tag_name_prefix = var.tag_name_prefix
  tag_owner = var.tag_owner
  tag_project = var.tag_project
}

resource "aws_ebs_volume" "volume_box1" {
    size = var.ebs_volume_box_1_size
    type = "gp2"
    availability_zone = module.box1.availability_zone
  
  tags = {
    Name = "${var.tag_name_prefix}-ebs-volume-1"
    Owner = var.tag_owner
    Project = var.tag_project
  }
}

resource "aws_volume_attachment" "volume_attachment_box1" {
  device_name = "/dev/xvdh"
  volume_id = aws_ebs_volume.volume_box1.id
  instance_id = module.box1.box_id
}

module "box2"{
  source = "../../common/terraform/modules/box"
  name_box = "box2"
  private_ip_box = "10.0.0.101"
  subnet_id = aws_subnet.dmz.id
  security_group_id = aws_security_group.sg_dmz.id
  ssh_key_box = var.ssh_key_name
  ami_box = var.ami_box_2
  instance_type_box = var.instance_type_box_2
  iam_instance_profile = aws_iam_instance_profile.cw_instance_profile.name
  tag_name_prefix = var.tag_name_prefix
  tag_owner = var.tag_owner
  tag_project = var.tag_project
}

resource "aws_ebs_volume" "volume_box2" {
    size = var.ebs_volume_box_2_size
    type = "gp2"
    availability_zone = module.box1.availability_zone
  
  tags = {
    Name = "${var.tag_name_prefix}-ebs-volume-2"
    Owner = var.tag_owner
    Project = var.tag_project
  }
}

resource "aws_volume_attachment" "volume_attachment_box2" {
  device_name = "/dev/xvdh"
  volume_id = aws_ebs_volume.volume_box2.id
  instance_id = module.box2.box_id
}


module "box3"{
  source = "../../common/terraform/modules/box"
  name_box = "box3"
  private_ip_box = "10.0.0.102"
  subnet_id = aws_subnet.dmz.id
  security_group_id = aws_security_group.sg_dmz.id
  ssh_key_box = var.ssh_key_name
  ami_box = var.ami_box_3
  instance_type_box = var.instance_type_box_3
  iam_instance_profile = aws_iam_instance_profile.cw_instance_profile.name
  tag_name_prefix = var.tag_name_prefix
  tag_owner = var.tag_owner
  tag_project = var.tag_project
}

resource "aws_ebs_volume" "volume_box3" {
    size = var.ebs_volume_box_3_size
    type = "gp2"
    availability_zone = module.box1.availability_zone
  
  tags = {
    Name = "${var.tag_name_prefix}-ebs-volume-3"
    Owner = var.tag_owner
    Project = var.tag_project
  }
}

resource "aws_volume_attachment" "volume_attachment_box3" {
  device_name = "/dev/xvdh"
  volume_id = aws_ebs_volume.volume_box3.id
  instance_id = module.box3.box_id
}