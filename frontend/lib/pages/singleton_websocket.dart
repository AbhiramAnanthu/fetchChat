import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

class WebsocketService {
  WebsocketService._internal();
  static final WebsocketService _instance = WebsocketService._internal();

  bool is_connected = true;

  factory WebsocketService() {
    return _instance;
  }

  WebSocketChannel? connect(String uri) {
    if (!is_connected) {
      WebSocketChannel _channel = WebSocketChannel.connect(Uri.parse(uri));
      is_connected = true;
      return _channel;
    }
  }

  Stream messages(WebSocketChannel? channel) => channel!.stream;

  void sendMessage(Map<String, dynamic> message, WebSocketChannel? channel) {
    if (channel == null) {
      print("channel is null");
    }
    if (is_connected) {
      channel!.sink.add(jsonEncode(message));
    }
  }

  void closeConnection(WebSocketChannel? channel) {
    if (is_connected) {
      channel!.sink.close(status.goingAway);
      is_connected = false;
    }
  }
}
