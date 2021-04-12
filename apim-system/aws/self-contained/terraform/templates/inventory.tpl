all:
  hosts:
    ${box_1_public_dns}
  children:
    mount_ebs:
      hosts:
        ${box_1_public_dns}
    docker_hosts:
      hosts:
        ${box_1_public_dns}
    platform_api:
      hosts:
        ${box_1_public_dns}
      vars:
        aws_log_group: ${aws_log_group}