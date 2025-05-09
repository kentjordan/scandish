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

  bool isSigningUp = false;
  bool isValidEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    void signup() async {
      setState(() {
        isSigningUp = true;
      });
      String email = _emailController.text;
      String password = _passwordController.text;
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;

      if (firstName.isEmpty ||
          lastName.isEmpty ||
          email.isEmpty ||
          password.isEmpty) {
        setState(() {
          isSigningUp = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please fill all fields"),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          isSigningUp = false;
        });
        return;
      }

      if (!isValidEmail(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter a valid email address.")),
        );
        setState(() {
          isSigningUp = false;
        });
        return;
      }
      if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password must be at least 6 characters.")),
        );
        setState(() {
          isSigningUp = false;
        });
        return;
      }
      _viewModel
          .signup(email, password)
          .then((data) {
            if (!data['success']) {
              showDialog(
                // ignore: use_build_context_synchronously
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      title: Text("Oops!"),
                      content: Text(
                        "Something went wrong when signing up. Please try again.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isSigningUp = false;
                            });

                            Navigator.of(ctx).pop();
                          },
                          child: Text("OK"),
                        ),
                      ],
                    ),
              );
            }
            Navigator.pushReplacementNamed(
              // ignore: use_build_context_synchronously
              context,
              "/view/home",
            );
          })
          .onError((error, _) {
            setState(() {
              isSigningUp = false;
              showDialog(
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      title: Text("Error"),
                      content: Text("Something went wrong. Please try again."),
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
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 8,
              children: [
                Image(
                  image: AssetImage("assets/logo.png"),
                  height: 300,
                  width: 300,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      textAlign: TextAlign.start,
                      "Create your account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextField(
                      style: TextStyle(fontSize: 12),
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        hintText: "First name",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: const Color(0xFFED9A48),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                    TextField(
                      style: TextStyle(fontSize: 12),
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        hintText: "Last name",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: const Color(0xFFED9A48),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                    TextField(
                      style: TextStyle(fontSize: 12),
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: const Color(0xFFED9A48),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                    TextField(
                      style: TextStyle(fontSize: 12),
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: const Color(0xFFED9A48),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isSigningUp ? null : signup,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: const Color(0xFFED9A48),
                    minimumSize: Size.fromHeight(40),
                  ),
                  child:
                      isSigningUp
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            "Signup",
                            style: TextStyle(color: Colors.white),
                          ),
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
      ),
    );
  }
}
