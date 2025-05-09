import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:scandish/providers/recipe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String? title;
  String? content;
  String? photoUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      if (mounted) {
        int recipeId = context.read<RecipeProvider>().id;
        Supabase.instance.client
            .from("recipes")
            .select()
            .eq("id", recipeId)
            .single()
            .then((data) {
              if (mounted) {
                setState(() {
                  title = data['title'];
                  content = data['content'];
                  photoUrl = data['photo'];
                });
              }
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            title != null && content != null && photoUrl != null
                ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
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
                        if (title != null &&
                            content != null &&
                            photoUrl != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              photoUrl ?? "",
                              width: double.infinity,
                              height: 256,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            title ?? "",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          MarkdownBody(data: content ?? ""),
                        ],
                      ],
                    ),
                  ),
                )
                : Center(
                  child: Expanded(
                    child: CircularProgressIndicator(
                      color: const Color(0xFFED9A48),
                    ),
                  ),
                ),
      ),
    );
  }
}
