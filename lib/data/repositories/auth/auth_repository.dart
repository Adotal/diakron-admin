import 'package:diakron_admin/data/services/auth_service.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  // Dependency injection
  AuthRepository({required AuthService authService})
    : _authService = authService;

  final AuthService _authService;

  Future<Result> login(String email, String password) async {
    final result = await _authService.sigInEmailPassword(
      email: email,
      password: password,
    );

    if (result is Error<AuthResponse>) {
      return Result.error(Exception('unknown_error'));
    }

    // Login successful

    // if(deleteSession) _authService.signOut
    return Result.ok(null);
  }

  Future<Result<void>> signUp({
    required String email,
    required String password,
  }) async {
    final result = await _authService.sigUpEmailPassword(
      email: email,
      password: password,
    );

    if (result is Error<AuthResponse>) {
      return Result.error(result.error);
    }
    // Sign up successful
    return Result.ok(null);

    // return await _authService.sigUpEmailPassword(email, password);
  }

  // In auth_repository.dart
  Future<Result<void>> logout() async {
    try {
      await _authService.signOut();
      return Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  String? getCurrentUserEmail() => _authService.getEmail();
}
