import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppSecrets {
  static late final String supabaseUrl;
  static late final String supabaseAnonKey;

  static Future<void> loadEnv() async {
    await dotenv.load(fileName: '.env');

    supabaseUrl = dotenv.env['supabaseUrl'] ?? '';
    supabaseAnonKey = dotenv.env['supabaseAnonKey'] ?? '';

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
          'Las variables supabaseUrl o supabaseAnonKey no están definidas correctamente en el archivo .env');
    }
  }
}
