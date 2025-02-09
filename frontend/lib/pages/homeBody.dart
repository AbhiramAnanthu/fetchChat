import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0, 0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "FetchChat",
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 62, fontWeight: FontWeight.bold),
          ),
          Text(
            "fetch,parse,chat 🚀",
            style: GoogleFonts.poppins(
                color: Colors.grey, fontSize: 22, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
