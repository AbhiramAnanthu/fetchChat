import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

class WebsocketService {
  WebsocketService._internal();
  static final WebsocketService _instance = WebsocketService._internal();

  late WebSocketChannel _channel;
  bool is_connected = true;

  factory WebsocketService() {
    return _instance;
  }

  void connect(String uri) {
    if (!is_connected) {
      _channel = WebSocketChannel.connect(Uri.parse(uri));
      is_connected = true;
    }
  }

  Stream get messages => _channel.stream;

  void sendMessage(Map<String, dynamic> message) {
    if (is_connected) {
      _channel.sink.add(jsonEncode(message));
    }
  }

  void closeConnection() {
    if (is_connected) {
      _channel.sink.close(status.goingAway);
      is_connected = false;
    }
  }
}
