import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseService {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    try {
      // Load environment variables
      await dotenv.load(fileName: ".env");

      final apiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';
      final projectId = dotenv.env['FIREBASE_PROJECT_ID'] ?? '';

      if (apiKey.isEmpty || apiKey.contains('your_') || projectId.isEmpty) {
        debugPrint('[FirebaseService] Placeholder or empty credentials in .env. Running in Mock Auth mode.');
        return;
      }

      final appId = kIsWeb
          ? (dotenv.env['FIREBASE_APP_ID_WEB'] ?? '')
          : defaultTargetPlatform == TargetPlatform.android
              ? (dotenv.env['FIREBASE_APP_ID_ANDROID'] ?? dotenv.env['FIREBASE_APP_ID_WEB'] ?? '')
              : (dotenv.env['FIREBASE_APP_ID_IOS'] ?? dotenv.env['FIREBASE_APP_ID_WEB'] ?? '');

      final options = FirebaseOptions(
        apiKey: apiKey,
        appId: appId.isNotEmpty ? appId : (dotenv.env['FIREBASE_APP_ID_WEB'] ?? ''),
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: projectId,
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'],
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
        measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'],
      );

      await Firebase.initializeApp(options: options);
      _isInitialized = true;
      debugPrint('[FirebaseService] Firebase initialized successfully with projectId: $projectId');
    } catch (e) {
      debugPrint('[FirebaseService] Firebase init notice (falling back to graceful hybrid mode): $e');
    }
  }
}
