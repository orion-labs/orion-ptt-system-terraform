variable "image_id" {
  description   = "ID of the AMI you wish to use for EC2 Instances.  If not provided, we will autodetect the latest supported Ubuntu image."
  default       = ""
}

variable "instance-type" {
  default       = "m5.2xlarge"
}

variable "key_name" {
  description   = "Name of SSH key to be used for EC2 instances"
}

variable "k8s_node_name" {
  description   = "Name for the initial Kubernetes Node"
  default       = "orion-ptt-system"
}

variable "prefix" {
  description   = "A unique prefix for your resources to support multiple instances in parallel."
}

variable "subnet_id" {
  description   = "ID of your public subnet"
}

variable "volume_size" {
  description   = "Instance root volume size"
  default       = 50

}

variable "ami_owner" {
  description   = "Owner of AMI image to launch.  Defaults to Canonical."
  default       = "099720109477"
}

variable "ubuntu_version" {
  description = "Ubuntu version string used to find AMI ID if one is not specified."
  default       = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
}

variable "vpc_id" {
  description   = "ID of your VPC"
}

variable "create_dns" {
  description = "Whether to configure DNS Records in Route53."
  default = false
}


variable "dns_zone_id" {
  description = "Route53 Zone ID.  (Required to configure Route53.)"
  default = ""
}

variable "domain" {
  description = "DNS Domain.  Service records will be created on this domain.  It must be one you control.  (Required to configure Route53.)"
  default = ""
}

variable "vpc_name" {
  default = "Orion PTT System"
  description = "Name of the VPC to create"
}

variable "vpc_network" {
  default = "10.44.0.0/21"
  description = "IPv4 CIDR for your VPC's network"
}

variable "public_subnet_cidr" {
  default = "10.44.0.0/24"
  description = "IPv4 CIDR Block for Public Subnet"
}

variable "public_subnet_az" {
  default = "us-east-1a"
  description = "Public Subnet Availability Zone"
}

variable "create_vpc" {
  description = "Whether to create a VPC"
  default = false
}
