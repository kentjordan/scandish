import 'package:flutter/material.dart';
import 'package:scandish/viemodel/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthViewmodel _viewmodel = AuthViewmodel();

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
                  controller: _emailController,
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
                  controller: _passwordController,
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
                  onPressed: () async {
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    Map<String, dynamic> res = await _viewmodel.login(
                      email,
                      password,
                    );
                    print(res);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(48),
                  ),
                  child: Text("Login"),
                ),
                SizedBox(height: 24),
                TextButton(
                  onPressed:
                      () => {
                        Navigator.of(context).pushNamed("/view/auth/signup"),
                      },
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
