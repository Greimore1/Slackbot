provider "aws" {
  region = "eu-west-2"
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "slack-bot-vpc"
  }
}

# Subnets
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = "eu-west-2${count.index == 0 ? "a" : "b"}"
  
  tags = {
    Name = "slack-bot-public-subnet-${count.index + 1}"
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "slack_bot_cluster" {
  name = "slack-bot-cluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "slack_bot" {
  family                   = "slack-bot-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "slack-bot"
    image = "${aws_ecr_repository.slack_bot.repository_url}:latest"
    environment = [
      {
        name  = "SLACK_BOT_TOKEN"
        value = var.slack_bot_token
      },
      {
        name  = "SLACK_APP_TOKEN"
        value = var.slack_app_token
      }
    ]
  }])
}

# ECR Repository
resource "aws_ecr_repository" "slack_bot" {
  name = "slack-bot-repository"
}

# IAM Role for ECS Execution
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

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

# Variables for sensitive information
variable "slack_bot_token" {
  description = "Slack Bot Token"
  type        = string
}

variable "slack_app_token" {
  description = "Slack App Token"
  type        = string
}
