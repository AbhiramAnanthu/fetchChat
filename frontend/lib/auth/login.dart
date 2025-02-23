import 'package:flutter/material.dart';
import 'package:frontend/auth/authService.dart';
import 'package:frontend/auth/signup.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

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
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: 32.0,
          bottom: 32.0,
          left: 12.0,
          right: 12.0,
        ),
        padding: EdgeInsets.only(top: 24.0, bottom: 24.0),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(25.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _login_section(context),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Or",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Signin with Google"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container _login_section(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Login",
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: TextField(
              style: GoogleFonts.poppins(color: Colors.white),
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: "Username",
                labelStyle: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            child: TextField(
              style: GoogleFonts.poppins(color: Colors.white),
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: "password",
                labelStyle: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                fixedSize: Size(150, 50),
                backgroundColor: Color(0xffe63946),
              ),
              onPressed: () {
                AuthService().signIn(
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context);
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
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
                style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: Colors.transparent),
                child: Text(
                  "SignUp",
                  style: GoogleFonts.poppins(
                    color: Color(0xffe63946),
                    fontSize: 16.0,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
