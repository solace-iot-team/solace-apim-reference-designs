output "public_ip" {
    value = aws_eip.public_ip_box.public_ip
}
output "public_dns" {
    value = aws_eip.public_ip_box.public_dns
}

output "availability_zone" {
    value = aws_instance.box.availability_zone
}

output "box_id" {
    value = aws_instance.box.id
}