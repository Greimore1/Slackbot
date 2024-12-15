import os
from slack_bolt import App
from slack_bolt.adapter.socket_mode import SocketModeHandler
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Initialize the Slack app with your Bot Token and Socket Mode Token
app = App(token=os.environ.get("SLACK_BOT_TOKEN"))

@app.message("hello")
def say_hello(message, say):
    """
    Respond to 'hello' messages in Slack
    """
    say(f"Hey there <@{message['user']}>! How can I help you today?")

@app.message("help")
def provide_help(message, say):
    """
    Provide help information
    """
    help_text = """
    Here are some things I can help you with:
    • Say 'hello' to get a greeting
    • Say 'help' to see this message
    • More features coming soon!
    """
    say(help_text)

# Use default handler instead of fallback
@app.event("message")
def handle_message(event, say):
    """
    Default handler for messages not matching specific patterns
    """
    say("I'm not sure I understand. Try saying 'help' to see what I can do.")

def start_bot():
    """
    Start the Slack bot
    """
    handler = SocketModeHandler(app, os.environ.get("SLACK_APP_TOKEN"))
    handler.start()

if __name__ == "__main__":
    start_bot()
