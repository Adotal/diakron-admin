import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in (login)
  Future<Result<AuthResponse>> sigInEmailPassword({
   required String email,
   required String password,
  }
  ) async {
    try {
      final result = _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return Result.ok(await result);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  // Sign up
  Future<Result<AuthResponse>> sigUpEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return Result.ok(result);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Send email password recover

  Future<void> sendEmailforgetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: kIsWeb
          ? null
          : 'io.supabase.flutterquickstart://callback/reset-password/',
    );
  }

  // Update user password
  Future<UserResponse> updateUserPassword(String password) async {
    return await _supabase.auth.updateUser(UserAttributes(password: password));
  }

  // get Email
  String? getEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;

    return user?.email;
  }
}
