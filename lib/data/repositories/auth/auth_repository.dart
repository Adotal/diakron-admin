import 'package:diakron_admin/data/services/auth_service.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<Result> login(String email, String password) async {
    // You can add extra logic here, like mapping errors to custom messages
    return _authService.sigInEmailPassword(email, password);
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await _authService.sigUpEmailPassword(email, password);
  }

  Future<void> logout() => _authService.signOut();

  String? getCurrentUserEmail() => _authService.getEmail();
}