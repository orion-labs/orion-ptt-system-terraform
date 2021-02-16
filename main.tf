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

  owners = [var.ami_owner]
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
  vpc_id      = var.vpc_id
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

resource "aws_route53_record" "alnilam" {
  zone_id = var.dns_zone_id
  name    = format("alnilam.%s", var.domain)
  type    = "A"
  records = [aws_instance.orion-ptt-system.public_ip]
  ttl     = 300
  count   = var.create_dns ? 1 : 0
}

resource "aws_route53_record" "atlas" {
  zone_id = var.dns_zone_id
  name    = format("atlas.%s", var.domain)
  type    = "A"
  records = [aws_instance.orion-ptt-system.public_ip]
  ttl     = 300
  count   = var.create_dns ? 1 : 0
}

resource "aws_route53_record" "icarus" {
  zone_id = var.dns_zone_id
  name    = format("icarus.%s", var.domain)
  type    = "A"
  records = [aws_instance.orion-ptt-system.public_ip]
  ttl     = 300
  count   = var.create_dns ? 1 : 0
}

resource "aws_route53_record" "observer" {
  zone_id = var.dns_zone_id
  name    = format("observer.%s", var.domain)
  type    = "A"
  records = [aws_instance.orion-ptt-system.public_ip]
  ttl     = 300
  count   = var.create_dns ? 1 : 0
}

resource "aws_route53_record" "rigel" {
  zone_id = var.dns_zone_id
  name    = format("rigel.%s", var.domain)
  type    = "A"
  records = [aws_instance.orion-ptt-system.public_ip]
  ttl     = 300
  count   = var.create_dns ? 1 : 0
}

resource "aws_route53_record" "task_queue" {
  zone_id = var.dns_zone_id
  name    = format("taskqueue.%s", var.domain)
  type    = "A"
  records = [aws_instance.orion-ptt-system.public_ip]
  ttl     = 300
  count   = var.create_dns ? 1 : 0
}

resource "aws_route53_record" "vault" {
  zone_id = var.dns_zone_id
  name    = format("vault.%s", var.domain)
  type    = "A"
  records = [aws_instance.orion-ptt-system.public_ip]
  ttl     = 300
  count   = var.create_dns ? 1 : 0
}

# The VPC
resource "aws_vpc" "orion-vpc" {
  count                 = var.create_dns ? 1 : 0
  cidr_block            = var.vpc_network
  enable_dns_hostnames  = true
  enable_dns_support    = true


  tags = {
    Name = var.vpc_name
  }
}

# internet gateway
resource "aws_internet_gateway" "gw" {
  count  = var.create_dns ? 1 : 0
  vpc_id = aws_vpc.orion-vpc[count.index].id

  tags = {
    Name = "main"
  }
}

# route tables
resource "aws_route_table" "public" {
  count  = var.create_dns ? 1 : 0
  vpc_id = aws_vpc.orion-vpc[count.index].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw[count.index].id

  }

  tags = {
    Name = "Orion PTT System Public Route Table"

  }
}

# subnets
resource "aws_subnet" "public_subnet" {
  count             = var.create_dns ? 1 : 0
  vpc_id            = aws_vpc.orion-vpc[count.index].id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.public_subnet_az

  tags = {
    Name = "Orion PTT System Public Subnet"
  }
}

resource aws_route_table_association "public" {
  count           = var.create_dns ? 1 : 0
  subnet_id       = aws_subnet.public_subnet[count.index].id
  route_table_id  = aws_route_table.public[count.index].id
}

