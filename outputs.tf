output "instance_public_ip" {
  value = aws_instance.orion-ptt-system.public_ip
}

output "instance_private_ip" {
  value = aws_instance.orion-ptt-system.private_ip
}
