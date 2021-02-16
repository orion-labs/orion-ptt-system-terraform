# Orion PTT System Terraform

[![Current Release](https://img.shields.io/github/release/orion-labs/orion-ptt-system-terraform.svg)](https://img.shields.io/github/release/orion-labs/orion-ptt-system-terraform.svg)

[![Circle CI](https://circleci.com/gh/orion-labs/orion-ptt-system-terraform.svg?style=shield)](https://circleci.com/gh/orion-labs/orion-ptt-system-terraform)

Terraform module for configuring the Orion PTT System on AWS.

Leverage [Terraform](https://www.terraform.io/) to create a Kubernetes Cluster on Amazon EC2 together with Security Groups and Load Balancers sufficient to enable access from the internet to the Orion PTT System.

# Prerequisites

* [Terraform](https://www.terraform.io/) version 0.12 or higher

* AWS API Credentials with enough power to create resources in your VPC.

# Installation

1. Clone the repository [https://github.com/orion-labs/orion-ptt-system-terraform](https://github.com/orion-labs/orion-ptt-system-terraform)

1. From the root of the repository clone, initialize terraform by running: `terraform init`.

1. From the root of the repository clone, apply the config by running: `terraform apply`.  You will be asked for the following parameters:

    * **key_name** The name of an SSH Keypair registered with AWS

    * **prefix**  A unique prefix that gets prepended to all resources

    * **subnet_id** ID of the subnet in which EC2 instances will be created

    * **vpc_id** ID of your VPC

   Alternately, you can put these values in a file of the following form:

         key_name   = "Your Key Name"
         prefix     = "some-prefix"
         subnet_id  = "subnet-00ba34afc"
         vpc_id     = "vpc-44a237f"

   Then you can run: `tf apply -var-file=<filename>`.

   The output will look something like:

       data.aws_ami.ubuntu: Refreshing state...
       data.aws_vpc.default: Refreshing state...
       data.aws_subnet_ids.default: Refreshing state...

        An execution plan has been generated and is shown below.
        Resource actions are indicated with the following symbols:
        + create

        Terraform will perform the following actions:

        # aws_instance.orion-ptt-system will be created
        + resource "aws_instance" "orion-ptt-system" {
           + ami                          = "ami-007e8beb808004fdc"
           + arn                          = (known after apply)
           + associate_public_ip_address  = true
           + availability_zone            = (known after apply)
           + cpu_core_count               = (known after apply)
           + cpu_threads_per_core         = (known after apply)
           + ebs_optimized                = true
           + get_password_data            = false
           + host_id                      = (known after apply)
           + id                           = (known after apply)
           + instance_state               = (known after apply)
           + instance_type                = "m5.2xlarge"
           + ipv6_address_count           = (known after apply)
           + ipv6_addresses               = (known after apply)
           + key_name                     = "Nik"
           + outpost_arn                  = (known after apply)
           + password_data                = (known after apply)
           + placement_group              = (known after apply)
           + primary_network_interface_id = (known after apply)
           + private_dns                  = (known after apply)
           + private_ip                   = (known after apply)
           + public_dns                   = (known after apply)
           + public_ip                    = (known after apply)
           + secondary_private_ips        = (known after apply)
           + security_groups              = (known after apply)
           + source_dest_check            = true
           + subnet_id                    = "subnet-05a4fbb9c411619b5"
           + tags                         = {
              + "Name" = "tarfu-orion-ptt-system"
                }
           + tenancy                      = (known after apply)
           + user_data                    = "067a902923f3f0820d9027bea14c2154b2599dcb"
           + vpc_security_group_ids       = (known after apply)

           + ebs_block_device {
              + delete_on_termination = (known after apply)
              + device_name           = (known after apply)
              + encrypted             = (known after apply)
              + iops                  = (known after apply)
              + kms_key_id            = (known after apply)
              + snapshot_id           = (known after apply)
              + tags                  = (known after apply)
              + throughput            = (known after apply)
              + volume_id             = (known after apply)
              + volume_size           = (known after apply)
              + volume_type           = (known after apply)
                }

           + enclave_options {
              + enabled = (known after apply)
                }

           + ephemeral_block_device {
              + device_name  = (known after apply)
              + no_device    = (known after apply)
              + virtual_name = (known after apply)
                }

           + metadata_options {
              + http_endpoint               = (known after apply)
              + http_put_response_hop_limit = (known after apply)
              + http_tokens                 = (known after apply)
                }

           + network_interface {
              + delete_on_termination = (known after apply)
              + device_index          = (known after apply)
              + network_interface_id  = (known after apply)
                }

           + root_block_device {
              + delete_on_termination = true
              + device_name           = (known after apply)
              + encrypted             = (known after apply)
              + iops                  = (known after apply)
              + kms_key_id            = (known after apply)
              + throughput            = (known after apply)
              + volume_id             = (known after apply)
              + volume_size           = 50
              + volume_type           = "gp2"
                }
                }

            # aws_security_group.orion-ptt-system-k8s-node will be created
            + resource "aws_security_group" "orion-ptt-system-k8s-node" {
               + arn                    = (known after apply)
               + description            = "Allow traffic to Kubernetes"
               + egress                 = (known after apply)
               + id                     = (known after apply)
               + ingress                = (known after apply)
               + name                   = "tarfu-orion-ptt-system K8s Node"
               + owner_id               = (known after apply)
               + revoke_rules_on_delete = false
               + vpc_id                 = "vpc-22abf447"
                 }

            # aws_security_group_rule.k8s-http will be created
            + resource "aws_security_group_rule" "k8s-http" {
               + cidr_blocks              = [
                  + "0.0.0.0/0",
                    ]
               + description              = "tarfu Inbound Cleartext Application Traffic"
               + from_port                = 80
               + id                       = (known after apply)
               + protocol                 = "tcp"
               + security_group_id        = (known after apply)
               + self                     = false
               + source_security_group_id = (known after apply)
               + to_port                  = 80
               + type                     = "ingress"
                 }

            # aws_security_group_rule.k8s-https will be created
            + resource "aws_security_group_rule" "k8s-https" {
               + cidr_blocks              = [
                  + "0.0.0.0/0",
                    ]
               + description              = "Inbound Secure Application Traffic"
               + from_port                = 443
               + id                       = (known after apply)
               + protocol                 = "tcp"
               + security_group_id        = (known after apply)
               + self                     = false
               + source_security_group_id = (known after apply)
               + to_port                  = 443
               + type                     = "ingress"
                 }

            # aws_security_group_rule.k8s-kotsadm will be created
            + resource "aws_security_group_rule" "k8s-kotsadm" {
               + cidr_blocks              = [
                  + "0.0.0.0/0",
                    ]
               + description              = "Inbound Secure Application Traffic"
               + from_port                = 8800
               + id                       = (known after apply)
               + protocol                 = "tcp"
               + security_group_id        = (known after apply)
               + self                     = false
               + source_security_group_id = (known after apply)
               + to_port                  = 8800
               + type                     = "ingress"
                 }

            # aws_security_group_rule.k8s-node-outbound will be created
            + resource "aws_security_group_rule" "k8s-node-outbound" {
               + cidr_blocks              = [
                  + "0.0.0.0/0",
                    ]
               + description              = "outbound traffic"
               + from_port                = 0
               + id                       = (known after apply)
               + protocol                 = "-1"
               + security_group_id        = (known after apply)
               + self                     = false
               + source_security_group_id = (known after apply)
               + to_port                  = 65535
               + type                     = "egress"
                 }

            # aws_security_group_rule.ssh will be created
            + resource "aws_security_group_rule" "ssh" {
               + cidr_blocks              = [
                  + "0.0.0.0/0",
                    ]
               + description              = "Intra cluster traffic"
               + from_port                = 22
               + id                       = (known after apply)
               + protocol                 = "tcp"
               + security_group_id        = (known after apply)
               + self                     = false
               + source_security_group_id = (known after apply)
               + to_port                  = 22
               + type                     = "ingress"
                 }

            Plan: 7 to add, 0 to change, 0 to destroy.

            Do you want to perform these actions?
            Terraform will perform the actions described above.
            Only 'yes' will be accepted to approve.

            Enter a value:

   Enter `yes` to proceed with creation of the stack.

*NB: This terraform code will install the necessary infrastructure to run the Orion PTT System.  The system itself will not operate without a valid license from [Orion Labs](https://orionlabs.io).*

## DNS

The Terraform module at [https://github.com/orion-labs/orion-ptt-system-terraform](https://github.com/orion-labs/orion-ptt-system-terraform) can optionally configure DNS records via Route53.  DNS management is disabled by default.

To enable DNS via Route53, add the following optional variables in your variable file:

         dns_zone_id = "<Your Route53 DNS Zone ID"
         domain      = "<your domain name>"
         create_dns  = true

If you choose not to follow this step, you will need to set up DNS manually, or use the above repo as a module in your own terraform code that configures DNS independently.

To configure DNS Records manually, consult your DNS Provider, or see [https://aws.amazon.com/route53/](https://aws.amazon.com/route53/) for reference.


## VPC Creation

If you like, this repo will create a VPC for you.

Simply include the following in your variable file:

      create_vpc = true

By default it will create a VPC with a network of `34.203.14.50` and a subnet using `34.203.14.50` and an availability zome of `us-east-1a`.

You can override these values with the following in your variable file:


      create_vpc = true
      vpc_network = "10.44.0.0/21"
      public_subnet_cidr = "10.44.0.0/24"
      public_subnet_az = "us-east-1a"
