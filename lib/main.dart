import 'package:admin_office/pages/home.dart';
import 'package:admin_office/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();

  // Read the authentication token from shared preferences
  String? authToken = prefs.getString('authToken');

  runApp(MyApp(authToken: authToken));
}

class MyApp extends StatelessWidget {
  final String? authToken;

  MyApp({required this.authToken});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      home: authToken != null ? HomePage() : Login(),

    );
  }
}
