import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scandish/providers/image.dart';
import 'package:scandish/providers/recipe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PostgrestFilterBuilder<PostgrestList> recipes;
  final supabase = Supabase.instance.client;

  void getRecipes() {
    recipes = supabase
        .from("recipes")
        .select('id, created_at, title, content, photo');
  }

  void logout() {
    supabase.auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ScanDish",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: Text("Are you sure?"),
                              content: Text("You're logging out"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    logout();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("YES"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("NO"),
                                ),
                              ],
                            ),
                      );
                    },
                    child: Icon(Icons.logout),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          recipes = supabase
                              .from("recipes")
                              .select('id, created_at, title, content, photo');
                        });
                      },
                      child: Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.refresh, size: 16),
                          Text("Refresh"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: recipes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data != null) {
                    return snapshot.data!.isEmpty
                        ? Expanded(
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              "Tap the button below to\ngenerate your first recipe.",
                            ),
                          ),
                        )
                        : Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  context
                                      .read<RecipeProvider>()
                                      .setActiveRecipe(
                                        snapshot.data?[index]['id'],
                                      );
                                  Navigator.of(
                                    context,
                                  ).pushNamed("/view/recipe").then((_) {
                                    setState(() {
                                      getRecipes();
                                    });
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(4, 8, 4, 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        snapshot.data?[index]['photo'],
                                        width: 96,
                                        height: 96,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data?[index]['title'] ??
                                                    "[No title]",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 32),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (ctx) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              "Are you sure?",
                                                            ),
                                                            content: Text(
                                                              "You're deleting a recipe",
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () async {
                                                                  if (mounted) {
                                                                    await supabase
                                                                        .from(
                                                                          "recipes",
                                                                        )
                                                                        .delete()
                                                                        .eq(
                                                                          "id",
                                                                          snapshot
                                                                              .data?[index]['id'],
                                                                        );
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop();
                                                                    setState(() {
                                                                      getRecipes();
                                                                    });
                                                                  }
                                                                },
                                                                child: Text(
                                                                  "YES",
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  if (mounted) {
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop();
                                                                  }
                                                                },
                                                                child: Text(
                                                                  "NO",
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Icon(Icons.delete),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: const Color(0xFFED9A48),
        onPressed: () async {
          XFile? file = await ImagePicker().pickImage(
            source: ImageSource.camera,
          );

          if (!context.mounted) return;

          if (file != null) {
            context.read<ScandishImageProvider>().setImagePath(file.path);
            Navigator.of(context).pushNamed("/view/generate").then((_) {
              setState(() {
                getRecipes();
              });
            });
          }
        },
        child: Icon(Icons.add_a_photo_outlined, color: Colors.white),
      ),
    );
  }
}
