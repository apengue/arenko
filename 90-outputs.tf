output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.nginx_alb.dns_name
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.rds.endpoint
  sensitive   = true
}
