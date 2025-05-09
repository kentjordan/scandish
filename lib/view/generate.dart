import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:scandish/providers/image.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class Generate extends StatefulWidget {
  const Generate({super.key});

  @override
  State<Generate> createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  bool isCreatingRecipe = true;
  Map<String, dynamic> recipe = {"title": "", "content": ""};
  String? imagePath;
  SupabaseClient supabase = Supabase.instance.client;
  final localHost = "192.168.1.100:8000";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      generateRecipe(context, supabase);
    });
  }

  Future<void> generateRecipe(
    BuildContext context,
    SupabaseClient supabase,
  ) async {
    ScandishImageProvider provider = context.read<ScandishImageProvider>();
    String? imagePath = provider.imagePath;
    final url = Uri.http(localHost, "/generate");
    final req = http.MultipartRequest("POST", url);
    if (imagePath != null) {
      final file = await http.MultipartFile.fromPath("image", imagePath);
      req.files.add(file);
      final res = await req.send();
      res.stream.transform(utf8.decoder).listen((data) async {
        isCreatingRecipe = false;
        recipe = jsonDecode(jsonDecode(data)) as Map<String, dynamic>;
        String uploadPath = "uploads/${imagePath.split("/").last}";
        await supabase.storage
            .from("foods")
            .upload(uploadPath, File(imagePath));
        String imagePublicUrl = supabase.storage
            .from("foods")
            .getPublicUrl(uploadPath);
        await supabase.from("recipes").insert({
          "title": recipe['title'],
          "content": recipe['content'],
          "photo": imagePublicUrl,
          "user_id": supabase.auth.currentSession?.user.id,
        });
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScandishImageProvider provider = context.read<ScandishImageProvider>();
    String? imagePath = provider.imagePath;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    focusColor: Colors.amber[50],
                    splashColor: Colors.amber[600],
                    highlightColor: Colors.amber[600],
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        Icon(Icons.arrow_back),
                        Text(
                          "BACK",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (imagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(imagePath),
                      width: double.infinity,
                      height: 256,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 8),
                if (isCreatingRecipe)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 1),
                        ),
                        Text("Creating your recipe. Please wait."),
                      ],
                    ),
                  ),
                Text(
                  recipe['title'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  child: MarkdownBody(data: recipe['content']!),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
