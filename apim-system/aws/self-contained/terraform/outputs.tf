resource "local_file" "inventory_file" {
  content = templatefile("./templates/inventory.tpl",
    {
       box_1_public_ip = module.box1.public_ip
       box_1_public_dns = module.box1.public_dns
       aws_log_group = aws_cloudwatch_log_group.async-api-platform.name
    }
  )
  filename = "../generated/inventory"
}

resource "local_file" "boxes_file" {
  content = templatefile("./templates/boxes.tpl",
    {
       box_1_public_ip = module.box1.public_ip
       box_1_public_dns = module.box1.public_dns
    }
  )
  filename = "../generated/boxes.json"
}