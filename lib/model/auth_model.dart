import 'package:supabase_flutter/supabase_flutter.dart';

class AuthModel {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse> login(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await _client.auth.signUp(email: email, password: password);
  }
}
