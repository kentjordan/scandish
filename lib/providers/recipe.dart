import 'package:flutter/material.dart';

class RecipeProvider extends ChangeNotifier {
  late int id;

  void setActiveRecipe(int id) {
    this.id = id;
    notifyListeners();
  }
}
