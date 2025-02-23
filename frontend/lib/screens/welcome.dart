import 'package:flutter/material.dart';
import 'package:frontend/auth/login.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void setIsLoggedIn() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 14, 44, 1),
      body: Container(
        padding: EdgeInsets.fromLTRB(15.0, 0, 0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "FetchChat",
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 62,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "fetch, parse, chat 🚀",
              style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 32.0, bottom: 32.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffe63946),
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                  fixedSize: Size(100.0, 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text(
                  "Login",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
