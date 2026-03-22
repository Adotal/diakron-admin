import 'package:diakron_admin/data/repositories/auth/auth_repository.dart';
import 'package:diakron_admin/data/services/auth_service.dart';
import 'package:diakron_admin/l10n/app_localizations.dart';
import 'package:diakron_admin/routing/router.dart';
import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize supabase
  await Supabase.initialize(
    url: 'https://ogvhpfeknqytcuarqudu.supabase.co',
    anonKey: 'sb_publishable_7u8z8XGsCZqW4yMS4nYjVw_0JLpy-tM',
  );

  runApp(
    MultiProvider(
      providers: [
        // Provider(create: (context) => AuthService()),
        Provider<AuthService>(create: (_) => AuthService()),
        // AuthRepository is a ChangeNotifier, so we MUST use ChangeNotifierProxyProvider
        ChangeNotifierProxyProvider<AuthService, AuthRepository>(
          create: (context) =>
              AuthRepository(authService: context.read<AuthService>()),
          update: (context, authService, previousRepository) {
            // This ensures if AuthService ever changed, the repo stays updated
            return previousRepository ??
                AuthRepository(authService: authService);
          },
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We use context.read() here because the Router handles its own
    // listeners via the refreshListenable property we set up earlier.
    final authRepository = context.read<AuthRepository>();

    return MaterialApp.router(
      // For localization and internation
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: [
        Locale('es'), // Spanish
        Locale('en'), //- English
      ],

      // Default locale
      locale: Locale("es"),

      title: 'Diakron Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.greenDiakron1,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        fontFamily: 'Arial', // Fuente genérica
      ),

      routerConfig: router(authRepository),
    );
  }
}
