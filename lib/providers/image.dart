import 'package:flutter/material.dart';

class ScandishImageProvider extends ChangeNotifier {
  String? imagePath;

  void setImagePath(String path) {
    imagePath = path;
    notifyListeners();
  }
}
