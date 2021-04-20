resource "local_file" "inventory_file" {
  content = templatefile("./templates/inventory.tpl",
    {
       box_1_public_ip = module.box1.public_ip
       box_1_public_dns = module.box1.public_dns
       aws_log_group = aws_cloudwatch_log_group.async-api-platform.name
    }
  )
  filename = var.ansible_inventory_file_name
}

resource "local_file" "boxes_file" {
  content = templatefile("./templates/boxes.tpl",
    {
       box_1_public_ip = module.box1.public_ip
       box_1_public_dns = module.box1.public_dns
    }
  )
  filename = var.boxes_file_name
}

resource "local_file" "ansible_infrastructure_vars" {
  content = templatefile("./templates/ansible_infrastructure_vars.tpl",
    {
       box_1_public_ip = module.box1.public_ip
       box_1_public_dns = module.box1.public_dns
       box_1_comment =  "Project [${var.tag_project}] Owner [${var.tag_owner}]"
       aws_region = var.aws_region
       allowed_inbound_cidr_blocks = "see configuration file"
       instance_type_box_1 = var.instance_type_box_1
       tag_owner = var.tag_owner
       tag_project = var.tag_project
       tag_name_prefix = var.tag_name_prefix
    }
  )
  filename = var.generated_infrastructure_vars_file
}