import 'package:flutter/material.dart';

class UrlInput extends StatelessWidget {
  const UrlInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          // Prevents overflow
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              fillColor: Color.fromRGBO(10, 14, 44, 1),
              filled: true, // Ensure fillColor works
            ),
          ),
        ),
        SizedBox(width: 10), // Adds spacing
        ElevatedButton(
          onPressed: () {},
          child: Text("Load"),
        ),
      ],
    );
  }
}
