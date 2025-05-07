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
  bool isValidEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    void login() async {
      setState(() {
        isLoggingIn = true;
        String email = _emailController.text;
        String password = _passwordController.text;

        if (email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Please fill in all fields.")));
          setState(() {
            isLoggingIn = false;
          });
          return;
        }

        if (!isValidEmail(email)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please enter a valid email address.")),
          );
          setState(() {
            isLoggingIn = false;
          });
          return;
        }

        if (password.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password must be at least 6 characters.")),
          );
          setState(() {
            isLoggingIn = false;
          });
          return;
        }

        _viewmodel
            .login(email, password)
            .then((data) {
              if (!data['success']) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red[800],
                    content: Text(
                      data['error'].code == "invalid_credentials"
                          ? "Invalid email or password"
                          : "Something went wrong when logging in. Please try again.",
                    ),
                  ),
                );
                setState(() {
                  isLoggingIn = false;
                });
                return;
              }
              Navigator.of(
                // ignore: use_build_context_synchronously
                context,
              ).pushReplacementNamed("/view/home");
            })
            .onError((error, _) {
              setState(() {
                isLoggingIn = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Something went wrong. Please try again."),
                  ),
                );
              });
            });
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
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
                onPressed: isLoggingIn ? null : login,
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
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                        : Text("Login", style: TextStyle(color: Colors.white)),
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
    );
  }
}
