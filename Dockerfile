# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Set environment variables
ENV SLACK_BOT_TOKEN=""
ENV SLACK_APP_TOKEN=""
ENV GOOGLE_API_KEY=""

# Run the application
CMD ["python", "slack_bot.py"]
