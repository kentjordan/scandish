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

  bool isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: "Email",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: const Color(0xFFED9A48)),
                    ),
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: const Color(0xFFED9A48)),
                    ),
                    contentPadding: EdgeInsets.all(8),
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed:
                      isLoggingIn
                          ? null
                          : () async {
                            setState(() {
                              isLoggingIn = true;
                              String email = _emailController.text;
                              String password = _passwordController.text;
                              _viewmodel
                                  .login(email, password)
                                  .then((data) {
                                    if (!data['success']) {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (ctx) => AlertDialog(
                                              title: Text("Oops!"),
                                              content: Text(
                                                data['error'].code ==
                                                        "invalid_credentials"
                                                    ? "Invalid email or password"
                                                    : "Something went wrong when logging in. Please try again.",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isLoggingIn = false;
                                                    });
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: Text("OK"),
                                                ),
                                              ],
                                            ),
                                      );
                                    }
                                  })
                                  .onError((error, _) {
                                    setState(() {
                                      isLoggingIn = false;
                                      showDialog(
                                        context: context,
                                        builder:
                                            (ctx) => AlertDialog(
                                              title: Text("Error"),
                                              content: Text(
                                                "Something went wrong. Please try again.",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: Text("OK"),
                                                ),
                                              ],
                                            ),
                                      );
                                    });
                                  });
                            });
                          },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: const Color(0xFFED9A48),
                    minimumSize: Size.fromHeight(40),
                  ),
                  child:
                      isLoggingIn
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
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
