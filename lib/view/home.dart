import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scandish/providers/image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "ScanDish",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[600],
        onPressed: () async {
          XFile? file = await ImagePicker().pickImage(
            source: ImageSource.camera,
          );

          if (!context.mounted) return;

          if (file != null) {
            context.read<ScandishImageProvider>().setImagePath(file.path);
            Navigator.of(context).pushNamed("/view/generate");
          }
        },
        child: Icon(Icons.add_a_photo_outlined, color: Colors.white),
      ),
    );
  }
}
