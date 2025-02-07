from flask import Flask, request, jsonify
from flask_socketio import SocketIO, emit, Namespace
from Rag_application.rag import *

socketio = SocketIO(logger=True, engineio_logger=True, cors_allowed_origins="*")

app = Flask(__name__)
socketio.init_app(app)


@app.route("/", methods=["GET"])
def index():
    return {"message": "Welcome to FetchChat"}


@app.route("/api/load-engine/<userId>", methods=["GET"])
def load_engine(userId):
    """
    Request format
    GET api/:userId/load_engine/?namespace="namespace"/?url="url"
    """
    namespace, url = request.args
    if namespace and url:
        status = check_url_exists(namespace=namespace, url=url)
        if status:
            create_record(url=url, userId=userId, namespace=namespace)
        query_engine = load_query_engine(namespace=namespace, userId=userId, url=url)


class ChatNameSpace(Namespace):
    def on_connect(self):
        emit("response", {"message": "Client connected"})

    def on_disconnect(self):
        emit("response", {"message": "Client disconnected"})

    def on_message(self, data):
        emit("message", data)


socketio.on_namespace(ChatNameSpace("/chat"))

if __name__ == "__main__":
    socketio.run(app, debug=True)
