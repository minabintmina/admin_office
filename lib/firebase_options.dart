// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAmzb3lvRIQr-4BjwnOJAFuR0l22lHaviw',
    appId: '1:466783074684:web:e414c407e6fcb2c8500cf9',
    messagingSenderId: '466783074684',
    projectId: 'purair-a8c72',
    authDomain: 'purair-a8c72.firebaseapp.com',
    storageBucket: 'purair-a8c72.appspot.com',
    measurementId: 'G-FD6LJ3GWBM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5J-1Jv3GI7Om9_xt8HKEIds9aGFUzds8',
    appId: '1:466783074684:android:0d8d11a17e262766500cf9',
    messagingSenderId: '466783074684',
    projectId: 'purair-a8c72',
    storageBucket: 'purair-a8c72.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCgtKgDqT96TnWcIIJbTjwW4oO8ouDiNw',
    appId: '1:466783074684:ios:374c36ee130765d8500cf9',
    messagingSenderId: '466783074684',
    projectId: 'purair-a8c72',
    storageBucket: 'purair-a8c72.appspot.com',
    iosBundleId: 'com.admin.adminOffice',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDCgtKgDqT96TnWcIIJbTjwW4oO8ouDiNw',
    appId: '1:466783074684:ios:68a29be1f56557f6500cf9',
    messagingSenderId: '466783074684',
    projectId: 'purair-a8c72',
    storageBucket: 'purair-a8c72.appspot.com',
    iosBundleId: 'com.admin.adminOffice.RunnerTests',
  );
}
