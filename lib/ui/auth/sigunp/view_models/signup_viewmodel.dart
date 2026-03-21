import 'package:diakron_admin/data/repositories/auth/auth_repository.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:logger/web.dart';

class SignupViewmodel {
  SignupViewmodel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    signup =
        Command1<void, (String email, String password, String confirmPassword)>(
          _signUp,
        );
  }

  final AuthRepository _authRepository;
  final Logger _logger = Logger();

  late Command1 signup;

  Future<Result<void>> _signUp((String, String, String) data) async {
    final (email, password, confirmPassword) = data;

    await Future.delayed(const Duration(seconds: 2));
    _logger.i("Email:$email\nPsw:$password\nconfPsw:$confirmPassword");

    if (password != confirmPassword ||
        password == '' ||
        confirmPassword == '') {
      return Result.error(Exception('pws_not_match'));
    }

    // Try to login
    final result = await _authRepository.signUp(
      email: email,
      password: password,
    );

    if (result is Error<void>) {
      _logger.w('Sign up failed! $result');
    }

    _logger.i('Sign up success! $result');

    return result;
  }
}
