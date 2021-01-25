data "aws_vpc" "default" {

}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id

}

# Autodetect Latest Ubuntu Image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ubuntu_version]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# initial instance installer with userdata to install kURL
resource "aws_instance" "orion-ptt-system" {
  ami                         = coalesce(var.image_id, data.aws_ami.ubuntu.id)
  instance_type               = var.instance-type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = true
  ebs_optimized               = true
  user_data                   = <<-EOF
    #!/bin/bash
    curl https://kurl.sh/orion-ptt-system | sudo bash
EOF

  tags = {
    Name        = "${var.prefix}-${var.k8s_node_name}"
  }

  vpc_security_group_ids = [
    aws_security_group.orion-ptt-system-k8s-node.id,
  ]

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"
  }
}

resource "aws_security_group" "orion-ptt-system-k8s-node" {
  name        = "${var.prefix}-orion-ptt-system K8s Node"
  description = "Allow traffic to Kubernetes"
  vpc_id      = coalesce(var.vpc_id, data.aws_vpc.default.id)
}

resource "aws_security_group_rule" "k8s-http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "TCP"

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.orion-ptt-system-k8s-node.id
  description       = "${var.prefix} Inbound Cleartext Application Traffic"
}

resource "aws_security_group_rule" "k8s-https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "TCP"

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.orion-ptt-system-k8s-node.id
  description       = "Inbound Secure Application Traffic"
}

resource "aws_security_group_rule" "k8s-kotsadm" {
  type      = "ingress"
  from_port = 8800
  to_port   = 8800
  protocol  = "TCP"

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.orion-ptt-system-k8s-node.id
  description       = "Inbound Secure Application Traffic"
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.orion-ptt-system-k8s-node.id
  description       = "Intra cluster traffic"
}

resource "aws_security_group_rule" "k8s-node-outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "ALL"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.orion-ptt-system-k8s-node.id
  description       = "outbound traffic"
}

