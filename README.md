# Slack Bot with AWS ECS Deployment
(AWS Deployment not yet functioning)

## Project Overview
This project creates a Slack chatbot deployed on AWS ECS using Docker and Terraform, with automated CI/CD via GitHub Actions.

## Prerequisites
- Python 3.9+
- Docker
- AWS Account
- Terraform
- Slack App Credentials

## Project Structure
```
.
├── slack_bot.py          # Main Slack bot application
├── requirements.txt      # Python dependencies
├── Dockerfile            # Docker configuration
├── main.tf               # Terraform infrastructure configuration
└── .github/
    └── workflows/
        └── ci-cd.yml     # GitHub Actions workflow
```

## Local Development Setup
1. Clone the repository
2. Install dependencies:
   ```
   pip install -r requirements.txt
   ```
3. Set environment variables:
   ```
   export SLACK_BOT_TOKEN=your_bot_token
   export SLACK_APP_TOKEN=your_app_token
   ```
4. Run the bot:
   ```
   python slack_bot.py
   ```

## Deployment Steps
### Docker
1. Build the Docker image:
   ```
   docker build -t slack-bot .
   ```
2. Run the Docker container:
   ```
   docker run -e SLACK_BOT_TOKEN -e SLACK_APP_TOKEN slack-bot
   ```

### AWS ECS Deployment
1. Initialize Terraform:
   ```
   terraform init
   ```
2. Plan the infrastructure:
   ```
   terraform plan
   ```
3. Apply the configuration:
   ```
   terraform apply
   ```

## GitHub Actions
The CI/CD pipeline automatically:
- Builds the Docker image
- Pushes to Amazon ECR
- Deploys to ECS

