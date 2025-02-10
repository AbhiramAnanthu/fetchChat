import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:frontend/pages/chat_page.dart';
import 'package:frontend/pages/singleton_websocket.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class UrlInput extends StatefulWidget {
  const UrlInput({super.key});

  @override
  State<UrlInput> createState() => _UrlInputState();
}

class _UrlInputState extends State<UrlInput> {
  final WebsocketService _websocket_service = WebsocketService();
  final TextEditingController _controller = TextEditingController();

  bool isLoaded = false;
  bool _show_ready = false;

  bool _show_loader = true;

  void _load_query_engine() {
    setState(() {
      _show_ready = true;
    });

    final String fetch_uri = _controller.text;

    final String uri = "ws://localhost:8000/chat";

    final String namespace = "tenant-abhiram";

    try {
      WebSocketChannel? _channel = WebSocketChannel.connect(Uri.parse(uri));
    } on WebSocketChannelException catch (e) {
      print(e);
    }

    // _websocket_service.sendMessage({
    //   "url": uri,
    //   "namespace": namespace,
    // }, _channel);

    // Stream channel_stream = _websocket_service.messages(_channel);
    // channel_stream.listen((messages) {
    //   if (messages.toString().toLowerCase() == "loaded query engine") {
    //     isLoaded = true;
    //   }
    // });
  }

  void _cancel_loader() {
    setState(() {
      _show_loader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.left,
                "Start Chatting",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 62,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.arrow_circle_right,
                        color: Colors.black,
                        size: 32.0,
                      ),
                      onPressed: _load_query_engine,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Color(0xfff1faee),
                    labelText: "paste your url ...",
                    labelStyle: GoogleFonts.poppins(
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              Container(
                child: _show_ready
                    ? AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: isLoaded ? _readyButton() : _loader(),
                      )
                    : SizedBox.shrink(),
              )
            ]));
  }

  Visibility _loader() {
    return Visibility(
      visible: _show_loader,
      child: Container(
        width: 400.0,
        padding: EdgeInsets.only(top: 24.0),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xffe63946),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "Loading Query engine",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: Colors.amber, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              onPressed: _cancel_loader,
              child: Text("Cancel"),
            )
          ],
        ),
      ),
    );
  }

  Padding _readyButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ChatScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(150.0, 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          backgroundColor: Color(0xffe63946),
        ),
        child: Text(
          "Ready",
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
