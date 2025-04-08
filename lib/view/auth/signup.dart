import 'package:flutter/material.dart';
import 'package:scandish/viemodel/auth_viewmodel.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _viewModel = AuthViewmodel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 8,
            children: [
              Image(
                image: AssetImage("assets/logo.png"),
                height: 300,
                width: 300,
              ),
              Text("Signup", style: TextStyle(fontSize: 16)),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: "First name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: "Last name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  Map<String, dynamic> res = await _viewModel.signup(
                    email,
                    password,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(48),
                ),
                child: Text("Signup"),
              ),
              TextButton(
                onPressed:
                    () => {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed("/view/auth/login"),
                    },
                child: Text(
                  "Have an account? Login",
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
