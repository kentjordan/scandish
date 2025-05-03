import 'package:flutter/material.dart';
import 'package:scandish/view/auth/login.dart';
import 'package:scandish/view/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGuardScreen extends StatefulWidget {
  const AuthGuardScreen({super.key});

  @override
  State<AuthGuardScreen> createState() => _AuthGuardScreenState();
}

class _AuthGuardScreenState extends State<AuthGuardScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        print("Guard");
        print("Session");
        print(snapShot.data?.session);
        print("Data");
        print(snapShot.data);
        print(snapShot.hasData && snapShot.data?.session != null);

        if (snapShot.hasData && snapShot.data?.session != null) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
