test:
	@echo 'provider "aws" { region = "us-east-1" }' > aws.tf
	@terraform validate
	@rm aws.tf
