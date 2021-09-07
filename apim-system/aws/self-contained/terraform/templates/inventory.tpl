all:
  hosts:
    ${box_1_public_ip}
  children:
    mount_ebs:
      hosts:
        ${box_1_public_ip}
    docker_hosts:
      hosts:
        ${box_1_public_ip}
    platform_api:
      hosts:
        ${box_1_public_ip}
      vars:
        aws_log_group: ${aws_log_group}