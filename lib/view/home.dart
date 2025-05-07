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
        .select('id, created_at, title, content, photo')
        .eq('user_id', supabase.auth.currentUser!.id);
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
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    focusColor: Colors.amber[50],
                    splashColor: Colors.amber[600],
                    highlightColor: Colors.amber[600],
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
                                    Navigator.of(
                                      context,
                                    ).pushReplacementNamed("/view/auth/login");
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
                    InkWell(
                      borderRadius: BorderRadius.circular(4),
                      focusColor: Colors.amber[50],
                      splashColor: Colors.amber[600],
                      highlightColor: Colors.amber[600],
                      onTap: () async {
                        setState(() {
                          recipes = supabase
                              .from("recipes")
                              .select('id, created_at, title, content, photo')
                              .eq('user_id', supabase.auth.currentUser!.id);
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
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            "No recipes found.\nTap the button below to generate your first recipe.",
                          ),
                        ),
                      );
                    } else {
                      if (snapshot.data!.isNotEmpty) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(8),
                                focusColor: Colors.amber[50],
                                splashColor: Colors.amber[700],
                                highlightColor: Colors.amber[700],
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
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipOval(
                                          child: Image.network(
                                            snapshot.data?[index]['photo'],
                                            width: 64,
                                            height: 64,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${snapshot.data?[index]['title'].toString().substring(0, 24)}...",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${snapshot.data?[index]['content'].toString().substring(0, 40)}...",
                                                    softWrap: true,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                                                  // ignore: use_build_context_synchronously
                                                                  context,
                                                                ).pop();
                                                                setState(() {
                                                                  getRecipes();
                                                                });
                                                              }
                                                            },
                                                            child: Text("YES"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              if (mounted) {
                                                                Navigator.of(
                                                                  context,
                                                                ).pop();
                                                              }
                                                            },
                                                            child: Text("NO"),
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

                      return Expanded(
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            "No recipes found.\nTap the button below to generate your first recipe.",
                          ),
                        ),
                      );
                    }
                  }

                  return Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: const Color(0xFFED9A48),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Loading your recipes...",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
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
