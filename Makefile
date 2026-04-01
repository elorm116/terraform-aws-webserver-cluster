# =============================================================================
# Makefile for terraform-aws-webserver-cluster
# =============================================================================

.PHONY: help test fmt init apply destroy clean

# Default target
help:
	@echo "Available commands:"
	@echo "  make test     - Run Terratest"
	@echo "  make fmt      - Format Terraform code"
	@echo "  make init     - Initialize Terraform"
	@echo "  make apply    - Deploy infrastructure"
	@echo "  make destroy  - Destroy infrastructure"
	@echo "  make clean    - Clean temporary files and test caches"

# =============================================================================
# Testing
# =============================================================================

test:
	@echo "Running Terratest..."
	go test -v -race ./test

# Run specific test (useful during development)
test-specific:
	go test -v -run TestWebserverCluster ./test

# =============================================================================
# Terraform Commands
# =============================================================================

fmt:
	@echo "Formatting Terraform code..."
	terraform fmt -recursive

init:
	@echo "Initializing Terraform..."
	terraform init

apply:
	@echo "Applying Terraform changes..."
	terraform apply

destroy:
	@echo "Destroying infrastructure..."
	terraform destroy

# =============================================================================
# Cleanup
# =============================================================================

clean:
	@echo "Cleaning up..."
	rm -rf .terraform/
	rm -f terraform.tfstate*
	rm -f *.tfstate.backup
	rm -rf test/.test/
	go clean -testcache

# =============================================================================
# Development Helpers
# =============================================================================

# Full cycle: format, init, apply, test
all: fmt init apply test

# Quick validation
validate:
	terraform init -backend=false
	terraform validate
	terraform fmt -check -recursive

.PHONY: help test fmt init apply destroy clean all validate test-specific