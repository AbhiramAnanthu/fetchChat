from flask_socketio import SocketIO, emit, Namespace


class ChatNameSpace(Namespace):
    def on_connect(self):
        pass

    def on_disconnect(self):
        emit("response", {"message": "Client disconnected"})

    def on_message(self, data):
        emit("message", data)
