# terraform-aws-webserver-cluster

A reusable Terraform module that deploys a **highly available web server cluster** on AWS using an Application Load Balancer (ALB) and an Auto Scaling Group (ASG).

## What this module creates

- Application Load Balancer + HTTP listener + forwarding rule
- Target Group with health checks
- Launch Template + Auto Scaling Group (ASG)
- Security Groups (ALB + instances)
- CloudWatch Log Group (log shipping/agent not configured by default)

## Architecture

Internet → ALB (HTTP) → EC2 instances (Apache `httpd`)

- Uses the **default VPC** and its subnets
- ASG spans available AZs (with one AZ excluded in `us-east-1` by zone id)

## Requirements

- Terraform ≥ 1.10.0
- AWS provider `~> 6.37`
- AWS credentials with permissions for EC2, ELBv2, Auto Scaling, and CloudWatch Logs

## Usage

### From Git tag (recommended)

```hcl
module "webserver_cluster" {
  source = "git::https://github.com/elorm116/terraform-aws-webserver-cluster.git?ref=v0.0.4"

  project_name = "my-project"
  team_name    = "devops"
  environment  = "dev"
  cluster_name = "web-dev"
}
```

### Full example (recommended for production)

```hcl
module "webserver_cluster" {
  source = "git::https://github.com/elorm116/terraform-aws-webserver-cluster.git?ref=v0.0.4"

  project_name = "dark-knight"
  team_name    = "platform"
  environment  = "prod"
  cluster_name = "dark-knight-web-prod"

  instance_type  = "t3.small"
  min_size       = 3
  max_size       = 12
  custom_message = "Welcome to Dark Knight Production"
}
```

After `terraform apply`, open the service using the `alb_dns_name` output.

## Destroy protection

By default, this module enables AWS-native deletion protection on the ALB (`enable_destroy_protection = true`).

- If deletion protection is enabled, ALB deletion will fail.
- To destroy cleanly: set `enable_destroy_protection = false`, run `terraform apply`, then run `terraform destroy`.
- Recommended: keep it enabled for real environments, disable for ephemeral stacks and tests.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_name` | Project name used for tagging and resource naming | `string` | n/a | yes |
| `team_name` | Team responsible for this infrastructure | `string` | `"devops"` | no |
| `environment` | Deployment environment (`dev`, `test`, `staging`, `prod`) | `string` | n/a | yes |
| `cluster_name` | Name of the webserver cluster | `string` | n/a | yes |
| `instance_type` | EC2 instance type | `string` | `"t3.micro"` | no |
| `server_port` | Port the web server listens on | `number` | `8080` | no |
| `alb_port` | Port the ALB listens on | `number` | `80` | no |
| `min_size` | Minimum number of instances in the ASG | `number` | `2` | no |
| `max_size` | Maximum number of instances in the ASG | `number` | `4` | no |
| `custom_message` | Message displayed on the homepage | `string` | `"Highly Available"` | no |
| `enable_destroy_protection` | Enable ALB deletion protection (disable for tests) | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| `alb_dns_name` | Public DNS name of the load balancer — paste this in your browser |
| `asg_name` | Name of the Auto Scaling Group |
| `alb_arn` | ARN of the Application Load Balancer |
| `target_group_arn` | ARN of the Target Group |

## Testing

### Quick checks (no AWS resources)

```bash
make validate
```

### Terratest (creates AWS resources)

This will provision real infrastructure in your AWS account and may incur costs:

```bash
make test
```

### Consumer project test (separate folder)

See `examples/consumer/` for a minimal root module that consumes this module via a local path.

```bash
terraform -chdir=examples/consumer init -backend=false
terraform -chdir=examples/consumer validate
```

## Release process (tag v0.0.4)

1. Ensure everything is formatted and validates:

```bash
make validate
```

2. Commit your changes.

3. Create and push the tag:

```bash
git tag -a v0.0.4 -m "Release v0.0.4"
git push origin v0.0.4
```

## Known limitations

- Currently uses the default VPC (custom VPC support coming soon)
- HTTP only (HTTPS support planned)
- Excludes one `us-east-1` zone id (`use1-az3`) to avoid known capacity constraints

## Contributing

Feel free to open issues or pull requests. This module is part of my 30 Day Terraform Challenge.

Made for learning and production use.

