import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage("assets/logo.png")),
                TextField(
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      // borderSide: BorderSide(width: 2, color: Colors.red),
                      gapPadding: 0,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      // borderSide: BorderSide(width: 2, color: Colors.red),
                      gapPadding: 0,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(48),
                  ),
                  child: Text("Login"),
                ),
                SizedBox(height: 24),
                TextButton(
                  onPressed:
                      () => {Navigator.of(context).pushNamed("/auth/signup")},
                  child: Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
