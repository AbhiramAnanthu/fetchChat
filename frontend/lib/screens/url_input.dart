import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/screens/chat_page.dart';
import 'package:frontend/models/websocket_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class InputUrl extends StatefulWidget {
  const InputUrl({super.key});

  @override
  State<InputUrl> createState() => _InputUrlState();
}

class _InputUrlState extends State<InputUrl> {
  final WebSocketInstance _instance = WebSocketInstance();
  final TextEditingController _controller = TextEditingController();

  bool _is_loaded = false;
  bool _show_clear_button = false;

  void _load_query_engine() async {
    _instance.connect();

    final Map<String, String> data = {
      "url": _controller.text,
      "namespace": "tenant-abhiram",
    };

    _instance.initStream();
    _instance.channel.sink.add(jsonEncode(data));

    _instance.messages.listen((msg) {
      if (msg.toLowerCase() == "engine loaded") {
        setState(() {
          _is_loaded = true;
        });
      }
    });
  }

  void onTextChange() {
    setState(() {
      _show_clear_button = _controller.text.isNotEmpty;
    });
  }

  void _clear_text() {
    _controller.clear();

    setState(() {
      _show_clear_button = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(onTextChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              "Start Chatting",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 62,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding:
                      EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                  ),
                  labelText: "Paste your url . . .",
                  focusColor: Colors.transparent,
                  suffixIcon: SizedBox(
                    width: 100.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: _show_clear_button,
                          child: IconButton(
                            onPressed: _clear_text,
                            icon: Icon(Icons.clear),
                          ),
                        ),
                        IconButton(
                          onPressed: _load_query_engine,
                          icon: Icon(Icons.arrow_right_alt),
                        )
                      ],
                    ),
                  )),
            ),
          ),
          Visibility(
            visible: _is_loaded,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffe63946),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  fixedSize: Size(100.0, 50.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ChatScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0); // Starts from right
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  "Ready",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
