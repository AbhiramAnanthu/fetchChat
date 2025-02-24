from websocket import WebSocket


socket = WebSocket.connect("ws://127.0.0.1:8000/chat")


# function to connect and chat, disconect when chat is finished
# A list of web urls of articles and questions
# A function to monitor errors

web_urls = [
    {
        "url": "https://developer.mozilla.org/en-US/docs/Web/JavaScript",
        "questions": [
            "What is this document about?",
            "What are some common non-browser environments where JavaScript is used?",
            "How does JavaScript support different programming paradigms? Can you name them?",
            "What is the significance of JavaScript being a 'prototype-based' language?",
            "What are the main standards governing JavaScript?"
        ]
    },
    {
        "url": "https://docs.flutter.dev/data-and-backend/state-mgmt/simple",
        "questions": [
            "What is the document about?",
            "What is state management in the context of Flutter apps, and why is it important?",
            "What are the differences between ephemeral state and app state in Flutter?",
            "What is the provider package in Flutter, and why is it recommended for beginners?",
            "What does 'declarative UI programming' mean, and how does it apply to Flutter?",
            "In the provided example, what are the two screens represented by MyCatalog and MyCart?",
            "In the context of this example app, what happens when an item is marked as 'added' in the catalog screen? How does the cart screen reflect this state?"
        ]
    }
]

def chat_with_agent(data: dict) -> bool:
    pass
