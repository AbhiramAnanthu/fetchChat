import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketInstance {
  late final WebSocketChannel _channel;

  void connect() async {
    _channel = WebSocketChannel.connect(
        Uri.parse("wss://fetchchat.onrender.com/chat"));

    try {
      await _channel.ready;
    } on SocketException catch (e) {
      print(e);
    } on WebSocketChannelException catch (e) {
      print(e);
    }
  }

  void sendMessage(Map<String, String> map) {
    _channel.sink.add(jsonEncode(map));
  }

  Stream get messages => _channel.stream;

  void disconnect() {
    _channel.sink.close();
  }
}
