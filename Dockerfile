# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Define environment variables (to be set when running)
ENV SLACK_BOT_TOKEN=""
ENV SLACK_APP_TOKEN=""

# Run the bot when the container launches
CMD ["python", "slack_bot.py"]
