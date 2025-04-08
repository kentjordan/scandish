import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:scandish/model/auth_model.dart';

class AuthViewmodel extends ChangeNotifier {
  final AuthModel _model = AuthModel();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      AuthResponse res = await _model.login(email, password);
      if (res.session != null) {
        notifyListeners();
        return {
          'success': true,
          'accessToken': res.session?.accessToken,
          'user': res.session?.user,
        };
      }
      throw Exception("Something went wrong.");
    } catch (e) {
      return {'success': false, 'error': e};
    }
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    try {
      AuthResponse res = await _model.signUp(email, password);
      if (res.user != null) {
        return {
          'success': true,
          'accessToken': res.session?.accessToken,
          'user': res.session?.user,
        };
      }
      throw Exception("Something went wrong.");
    } catch (e) {
      return {'success': false, 'error': e};
    }
  }
}
