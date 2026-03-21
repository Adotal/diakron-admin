// Routes manager
import 'package:diakron_admin/data/repositories/auth/auth_repository.dart';
import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/auth/forgot_password/widgets/forgot_password_screen.dart';
import 'package:diakron_admin/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:diakron_admin/ui/auth/login/widgets/login_screen.dart';
import 'package:diakron_admin/ui/auth/new_password/widgets/new_password_screen.dart';
import 'package:diakron_admin/ui/auth/sigunp/view_models/signup_viewmodel.dart';
import 'package:diakron_admin/ui/auth/sigunp/widgets/signup_screen.dart';
import 'package:diakron_admin/ui/home/view_models/home_viewmodel.dart';
import 'package:diakron_admin/ui/home/widgets/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GoRouter router = GoRouter(
  initialLocation: Routes.login,
  debugLogDiagnostics: true, // TESTING
  redirect: _redirect,

  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        final viewModel = LoginViewModel(
          authRepository: context.read<AuthRepository>(),
        );
        return LoginScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return HomeScreen(
          viewModel: HomeViewModel(
            authRepository: context.read<AuthRepository>(),
          ),
        );
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
      path: Routes.signup,
      builder: (context, state) {
        final viewModel = SignupViewmodel(authRepository: context.read<AuthRepository>());
        return SignupScreen(viewModel: viewModel);
      },
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final session = Supabase.instance.client.auth.currentSession;
  final bool loggedIn = (session != null);
  final bool loggingIn = (state.matchedLocation == Routes.login);

  // If logged in and in login page
  if (loggedIn && loggingIn) {
    return Routes.home;
  }

  // no need to redirect at all
  return null;

  // // If not logged in, go to login
  // if (!loggedIn) {
  //   return Routes.login;
  // }
  // // If the program arrived here, it has logged in
  // // if the user  still on the login page, send them to the home page
  // if (loggingIn) {
  //   return Routes.home;
  // }
}
