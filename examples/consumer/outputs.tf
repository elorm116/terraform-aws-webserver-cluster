output "alb_dns_name" {
  description = "Public DNS name of the load balancer"
  value       = module.webserver_cluster.alb_dns_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.webserver_cluster.asg_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.webserver_cluster.alb_arn
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = module.webserver_cluster.target_group_arn
}
