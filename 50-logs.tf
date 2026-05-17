resource "aws_cloudwatch_log_group" "ecs_nginx" {
  name              = "/ecs/${var.environment}-nginx"
  retention_in_days = 30
  tags = {
    Name        = "/ecs/${var.environment}-nginx"
    Environment = var.environment
  }
}
