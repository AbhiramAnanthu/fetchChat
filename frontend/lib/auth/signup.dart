import 'package:flutter/material.dart';
import 'package:frontend/auth/authService.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(9, 14, 44, 1),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: Text(
          "FetchChat",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 32.0),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 52.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "SignUp",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextField(
                style: GoogleFonts.poppins(color: Colors.white),
                controller: _emailController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  labelText: "username",
                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextField(
                style: GoogleFonts.poppins(color: Colors.white),
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  labelText: "password",
                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffe63946),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  fixedSize: Size(150, 50)),
              onPressed: () async {
                AuthService().signUp(
                    email: _emailController.text,
                    password: _passwordController.text);
              },
              child: Text(
                "SignUp",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
