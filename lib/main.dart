import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scandish/providers/recipe.dart';
import 'package:scandish/view/auth/guard.dart';
import 'package:scandish/view/auth/login.dart';
import 'package:scandish/view/auth/signup.dart';
import 'package:scandish/view/generate.dart';
import 'package:scandish/view/home.dart';
import 'package:scandish/view/recipe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:scandish/providers/image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://fvorpcfvxptqrsskbhxp.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2b3JwY2Z2eHB0cXJzc2tiaHhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQxMTMzNzYsImV4cCI6MjA1OTY4OTM3Nn0.ZC-Ecmqm2lDogOWNJVi0Cdb6vyo3s959ZMLCoc-0LnU",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ScandishImageProvider()),
        ChangeNotifierProvider(create: (ctx) => RecipeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/view/auth/guard",
        routes: {
          "/view/auth/guard": (ctx) => AuthGuardScreen(),
          "/view/auth/login": (ctx) => LoginScreen(),
          "/view/auth/signup": (ctx) => SignupScreen(),
          "/view/home": (ctx) => HomeScreen(),
          "/view/generate": (ctx) => Generate(),
          "/view/recipe": (ctx) => RecipeScreen(),
        },
        title: 'ScanDish',
      )
    );
  }
}
