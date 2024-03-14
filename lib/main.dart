import 'dart:developer';
import 'package:admin_office/pages/home.dart';
import 'package:admin_office/pages/login/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  log("FCMToken |$fcmToken |");
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Simplified handling: Print the message content to the console
  });

  // Read the authentication token from shared preferences
  String? authToken = prefs.getString('authToken');

  runApp(MyApp(authToken: authToken));
}

class MyApp extends StatefulWidget {
  final String? authToken;

  const MyApp({super.key, required this.authToken});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoCondensedTextTheme(),
      ),
      home: widget.authToken != null ? const HomePage() : const Login(),
    );
  }
}
