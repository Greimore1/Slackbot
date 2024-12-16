provider "aws" {
  region = var.aws_region
}

# ECS Cluster
resource "aws_ecs_cluster" "slack_chatbot_cluster" {
  name = "slack-chatbot-cluster"
}

# ECS Task Definition without creating execution role
resource "aws_ecs_task_definition" "slack_chatbot_task" {
  family                   = "slack-chatbot-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.execution_role_arn  # Use existing execution role

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
}
