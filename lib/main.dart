import 'package:flutter/material.dart';
import 'package:scandish/auth/login.dart';
import 'package:scandish/auth/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/auth/login",
      routes: {
        "/auth/login": (ctx) => LoginScreen(),
        "/auth/signup": (ctx) => SignupScreen(),
      },
      title: 'ScanDish',
      home: Scaffold(),
    );
  }
}
