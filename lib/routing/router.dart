// Routes manager
import 'package:diakron_admin/data/repositories/auth/auth_repository.dart';
import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/auth/forgot_password/widgets/forgot_password_screen.dart';
import 'package:diakron_admin/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:diakron_admin/ui/auth/login/widgets/login_screen.dart';
import 'package:diakron_admin/ui/auth/new_password/widgets/new_password_screen.dart';
import 'package:diakron_admin/ui/auth/sigunp/widgets/signup_screen.dart';
import 'package:diakron_admin/ui/home/widgets/home_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: Routes.login,

  debugLogDiagnostics: true,  // TESTING
  
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return LoginScreen(viewModel: LoginViewModel(authRepository: AuthRepository()),);
      },
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: Routes.forgotpassword,
      builder: (context, state) {
        return const ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: Routes.newpassword,
      builder: (context, state) {
        return const NewPasswordScreen();
      },
    ),
    GoRoute(
      path: Routes.singup,
      builder: (context, state) {
        return const SignupScreen();
      },
    ),
  ],
);