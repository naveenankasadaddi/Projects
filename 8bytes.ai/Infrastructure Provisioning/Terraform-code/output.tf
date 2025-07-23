output "alb_dns_name" {
  description = "Application Load Balancer DNS"
  value       = aws_lb.app_alb.dns_name
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.app_server.id
}

output "rds_endpoint" {
  description = "PostgreSQL Endpoint"
  value       = aws_db_instance.postgres.endpoint
}
