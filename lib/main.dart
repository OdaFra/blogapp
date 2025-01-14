import 'package:blogapp/src/core/secrets/app_secrets.dart';
import 'package:flutter/material.dart';
import 'package:blogapp/src/core/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/features/auth/presentation/pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSecrets.loadEnv();

  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
    debug: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: const LoginPage(),
    );
  }
}
