// Routes manager
import 'package:diakron_admin/data/repositories/auth/auth_repository.dart';
import 'package:diakron_admin/data/repositories/users/collection_center_repository.dart';
import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/auth/forgot_password/view_models/forgot_password_viewmodel.dart';
import 'package:diakron_admin/ui/auth/forgot_password/widgets/forgot_password_screen.dart';
import 'package:diakron_admin/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:diakron_admin/ui/auth/login/widgets/login_screen.dart';
import 'package:diakron_admin/ui/auth/reset_password/view_models/reset_password_viewmodel.dart';
import 'package:diakron_admin/ui/auth/reset_password/widgets/reset_password_screen.dart';
import 'package:diakron_admin/ui/auth/sigunp/view_models/signup_viewmodel.dart';
import 'package:diakron_admin/ui/auth/sigunp/widgets/signup_screen.dart';
import 'package:diakron_admin/ui/collection_centers.dart/details/view_models/collection_center_details_viewmodel.dart';
import 'package:diakron_admin/ui/collection_centers.dart/details/widgets/collection_center_details_screen.dart';
import 'package:diakron_admin/ui/collection_centers.dart/table/view_models/collection_centers_viewmodel.dart';
import 'package:diakron_admin/ui/collection_centers.dart/table/widgets/collection_centers_screen.dart';
import 'package:diakron_admin/ui/home/view_models/home_viewmodel.dart';
import 'package:diakron_admin/ui/home/widgets/home_screen.dart';
import 'package:diakron_admin/ui/main/widgets/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.collectionCenters,
  debugLogDiagnostics: true, // TESTING
  refreshListenable: authRepository,
  redirect: _redirect,

  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
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
          path: Routes.map,
          builder: (_, _) => const Scaffold(body: Center(child: Text("Mapa"))),
        ),

        GoRoute(
          path: Routes.users,
          builder: (_, _) =>
              const Scaffold(body: Center(child: Text("Usuarios"))),
        ),

        GoRoute(
          path: Routes.finance,
          builder: (_, _) =>
              const Scaffold(body: Center(child: Text("Finanzas"))),
        ),

        GoRoute(
          path: Routes.settings,
          builder: (_, _) =>
              const Scaffold(body: Center(child: Text("Ajustes"))),
        ),
      ],
    ),

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
      path: Routes.forgotpassword,
      builder: (context, state) {
        final viewModel = ForgotPasswordViewmodel(
          authRepository: context.read<AuthRepository>(),
        );
        return ForgotPasswordScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.resetpassword,
      builder: (context, state) {
        final viewModel = ResetPasswordViewmodel(
          authRepository: context.read<AuthRepository>(),
        );
        return ResetPasswordScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.signup,
      builder: (context, state) {
        final viewModel = SignupViewmodel(
          authRepository: context.read<AuthRepository>(),
        );
        return SignupScreen(viewModel: viewModel);
      },
    ),

    GoRoute(
      path: Routes.collectionCenters,
      builder: (context, state) {
        final viewModel = CollectionCentersViewmodel(
          ccenterRepository: context.read<CollectionCenterRepository>(),
        );
        return CollectionCentersScreen(viewModel: viewModel);
      },
      // Details screen
      routes: [
        GoRoute(
          path: ':id', // This matches the ${center.id} in your push
          builder: (context, state) {
            // Extract the ID from the URL path
            final String idString = state.pathParameters['id']!;
            final String centerId = idString;
            final CollectionCenterDetailsViewModel viewModel =
                CollectionCenterDetailsViewModel(
                  repository: context.read<CollectionCenterRepository>(),
                  centerId: centerId,
                );

            return CollectionCenterDetailsScreen(viewModel: viewModel);
          },
        ),
      ],
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final authRepo = context.read<AuthRepository>();
  final bool loggedIn = authRepo.isAuthenticated;

  // Locations
  final bool isAtLogin = state.matchedLocation == Routes.login;
  final bool isAtReset = state.matchedLocation == Routes.resetpassword;
  final bool isAtForgot = state.matchedLocation == Routes.forgotpassword;
  final bool isAtSignup = state.matchedLocation == Routes.signup;

  // 1. HIGHEST PRIORITY: Password Recovery
  // If Supabase tells us we are in recovery mode, force the reset page.
  if (authRepo.isRecoveringPassword) {
    return isAtReset ? null : Routes.resetpassword;
  }

  // 2. If not logged in, and not on an "Auth" page (login, signup, forgot), go to Login
  if (!loggedIn) {
    if (isAtLogin || isAtForgot || isAtSignup || isAtReset) {
      return null;
    }
    return Routes.login;
  }

  // 3. If logged in but trying to hit the login or signup page, go Home
  // if (loggedIn && (isAtLogin || isAtSignup)) {
  //   return Routes.home;
  // }

  return null;
}
