import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketInstance {
  late final WebSocketChannel _channel;

  WebSocketInstance._privateConstructor();

  static final WebSocketInstance _instance =
      WebSocketInstance._privateConstructor();

  final StreamController<String> _bc_controller =
      StreamController<String>.broadcast();

  factory WebSocketInstance() {
    return _instance;
  }

  WebSocketChannel get channel => _channel;
  void connect() async {
    _channel = WebSocketChannel.connect(
      Uri.parse("wss://fetchchat.onrender.com/chat"),
    );

    try {
      await _channel.ready;
    } on SocketException catch (e) {
      print(e);
    } on WebSocketChannelException catch (e) {
      print(e);
    }
  }

  void initStream() {
    _channel.stream.listen(
      (message) {
        _bc_controller.add(message); // Broadcast message
      },
      onDone: () {
        _bc_controller.close(); // Close when WebSocket disconnects
      },
      onError: (error) {
        print("WebSocket Error: $error");
      },
    );
  }

  Stream<String> get messages => _bc_controller.stream;
  void disconnect() {
    _channel.sink.close();
  }
}
