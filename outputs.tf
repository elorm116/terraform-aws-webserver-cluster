output "alb_dns_name" {
  description = "Public DNS name of the load balancer — paste this in your browser"
  value       = aws_lb.web.dns_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.web.arn
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.web.arn
}

output "instance_type_used" {
  description = "The EC2 instance type being used by the ASG"
  value       = var.instance_type
}