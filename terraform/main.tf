provider "aws" {
  region = var.aws_region
}

# ECS Cluster
resource "aws_ecs_cluster" "slack_chatbot_cluster" {
  name = "slack-chatbot-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "slack-chatbot-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "slack_chatbot_task" {
  family                   = "slack-chatbot-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  
  container_definitions = jsonencode([{
    name  = "slack-chatbot"
    image = var.container_image
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
    environment = [
      {
        name  = "SLACK_BOT_TOKEN"
        value = var.slack_bot_token
      },
      {
        name  = "GEMINI_API_KEY"
        value = var.gemini_api_key
      }
    ]
    # Add log configuration for better observability
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/slack-chatbot"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

# ECS Service
resource "aws_ecs_service" "slack_chatbot_service" {
  name            = "slack-chatbot-service"
  cluster         = aws_ecs_cluster.slack_chatbot_cluster.id
  task_definition = aws_ecs_task_definition.slack_chatbot_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  # Optional: Enable service discovery
  lifecycle {
    ignore_changes = [desired_count]
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "slack_chatbot_logs" {
  name              = "/ecs/slack-chatbot"
  retention_in_days = 30
}
