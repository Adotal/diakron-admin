import 'package:diakron_admin/data/repositories/auth/auth_repository.dart';
import 'package:diakron_admin/data/services/auth_service.dart';
import 'package:diakron_admin/l10n/app_localizations.dart';
import 'package:diakron_admin/routing/router.dart';
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
    MultiProvider(providers: [
      // Provider(create: (context) => AuthService()),
      Provider<AuthService>(create: (_) => AuthService()),
      ProxyProvider<AuthService, AuthRepository>(
          update: (_, authService, _) => AuthRepository(authService: authService),
        ),
    ],
     child: const MainApp()),     
    );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        primaryColor: const Color(0xFF387C11),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        fontFamily: 'Arial', // Fuente genérica
      ),

      routerConfig: router,
    );
  }
}