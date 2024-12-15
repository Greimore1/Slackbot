import os
import logging
import google.generativeai as genai
from slack_bolt import App
from slack_bolt.adapter.socket_mode import SocketModeHandler
from dotenv import load_dotenv

# Logging setup
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

# Configure Google Generative AI
genai.configure(api_key=os.environ.get("GOOGLE_API_KEY"))

# Initialize generative model
model = genai.GenerativeModel('gemini-pro')

# Initialize Slack app with bot token
app = App(token=os.environ.get("SLACK_BOT_TOKEN"))

def generate_ai_response(user_message):
    """Generate a response using Gemini AI"""
    try:
        response = model.generate_content(
            f"You are a helpful Slack bot assistant. Respond to the following message: {user_message}"
        )
        return response.text
    except Exception as e:
        logger.error(f"Error generating AI response: {e}")
        return "I'm having trouble generating a response right now. Please try again later."

@app.event("app_mention")
def handle_app_mention_events(event, say, logger):
    logger.info(f"App mentioned with event: {event}")
    # Extract the text from the event payload
    user_text = event.get("text", "").replace(f"<@{app.client.auth_test()['user_id']}>", "").strip()
    
    # Generate AI response
    ai_response = generate_ai_response(user_text)
    
    # Respond with AI-generated message
    say(ai_response)

@app.message("help")
def provide_help(message, say):
    help_text = generate_ai_response("Provide a helpful guide about what this bot can do")
    say(help_text)

def start_bot():
    # Initialize and start the SocketModeHandler
    handler = SocketModeHandler(app, os.environ.get("SLACK_APP_TOKEN"))
    handler.start()

if __name__ == "__main__":
    start_bot()
