import 'package:frontend/models/websocket_model.dart';
import 'package:flutter/material.dart';

class ChatModel {
  final List<Map<String, dynamic>> messages = [];

  final WebSocketInstance _instance = WebSocketInstance();

  void sendMessage(Map<String, dynamic> message) {
    messages.add(message);
    _instance.channel.sink.add(message['content']);

    _instance.messages.listen((message) {
      print(message);
      Map<String, dynamic> message_instance = {
        "isMe": false,
        "createdAt": DateTime.now(),
        "content": message
      };
      messages.add(message_instance);
    });
  }
}
