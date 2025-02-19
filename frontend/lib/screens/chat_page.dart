import 'package:flutter/material.dart';
import 'package:frontend/models/chat_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/models/websocket_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];

  final WebSocketInstance _instance = WebSocketInstance();

  void sendMessage(Map<String, dynamic> message) {
    messages.add(message);
    _instance.channel.sink.add(message['content']);
  }

  void handleMessage() {
    if (_controller.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "isMe": true,
        "createdAt": DateTime.now(),
        "content": _controller.text,
      };
      setState(() {
        sendMessage(message);
      });

      _controller.clear();

      _instance.messages.listen((message) {
        Map<String, dynamic> message_instance = {
          "isMe": false,
          "createdAt": DateTime.now(),
          "content": message
        };

        setState(() {
          messages.add(message_instance);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(9, 14, 44, 1),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(9, 14, 44, 1),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "FetchChat",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 32.0),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 8.0),
                color: Color.fromRGBO(9, 14, 44, 1),
                child: SingleChildScrollView(
                    child: Column(children: [
                  SizedBox(
                    height: 800.0,
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return ChatBubble(
                            message: messages[index]['content'],
                            isMe: messages[index]['isMe']);
                      },
                    ),
                  ),
                ])),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                  labelText: "message . . .",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.only(left: 16.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: handleMessage,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe; // true for sender, false for receiver

  const ChatBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isMe ? Color(0xffe63946) : Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: isMe ? Radius.circular(15) : Radius.zero,
            bottomRight: isMe ? Radius.zero : Radius.circular(15),
          ),
        ),
        child: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }
}
