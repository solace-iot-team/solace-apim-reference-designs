
resource "aws_eip" "public_ip_box" {
  vpc = true
  network_interface = aws_network_interface.nic_box.id 
  tags = {
    Name = "${var.tag_name_prefix}-${var.name_box}-ip"
    Owner = var.tag_owner
    Project = var.tag_project
  }
}

resource "aws_network_interface" "nic_box" {
  subnet_id   = var.subnet_id
  private_ips = [var.private_ip_box]
  security_groups = [ var.security_group_id ]
  
  tags = {
    Name = "${var.tag_name_prefix}-${var.name_box}-ip"
    Owner = var.tag_owner
    Project = var.tag_project
  }
}

resource "aws_instance" "box" {
  ami           = var.ami_box
  instance_type = var.instance_type_box
  key_name = var.ssh_key_box
  iam_instance_profile = var.iam_instance_profile

   network_interface {
     network_interface_id = aws_network_interface.nic_box.id
     device_index         = 0
   }

  tags = {
    Name = "${var.tag_name_prefix}-${var.name_box}"
    Owner = var.tag_owner
    Project = var.tag_project
  }
}
