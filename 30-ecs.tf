resource "aws_ecs_cluster" "nginx_cluster" {
  name = "${var.environment}-cluster"
}

resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx_task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu           = "256"
  memory        = "512"
  task_role_arn = aws_iam_role.ecs_task_role.arn

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "${var.environment}-nginx-container"
    image = "nginx:1.27.3"
    portMappings = [{
      containerPort = 80,
      hostPort      = 80,
    }]

  logConfiguration = {
    logDriver = "awslogs"
    options = {
      "awslogs-group"         = aws_cloudwatch_log_group.ecs_nginx.name
      "awslogs-region"        = var.aws_region
      "awslogs-stream-prefix" = "ecs"
    }
  }

  }])
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.environment}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_ecs_service" "nginx_service" {
  name            = "${var.environment}-${var.service}"
  cluster         = aws_ecs_cluster.nginx_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.web_1.id, aws_subnet.web_2.id]
    security_groups  = [aws_security_group.ecs_sgrp.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
    container_name   = "${var.environment}-nginx-container"
    container_port   = 80
  }

  depends_on = [aws_ecs_task_definition.nginx_task]
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
