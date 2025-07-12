// File: lib/firebase_options.dart
// Firebase configuration for portfolio-b70f4 project

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
        return windows;
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
    apiKey: 'AIzaSyCJm8j_mDGI61g8-2F3DOuA-qGr-4IN-sE',
    appId: '1:286224383926:web:07980cb1306e5d29878b17',
    messagingSenderId: '286224383926',
    projectId: 'portfolio-b70f4',
    authDomain: 'portfolio-b70f4.firebaseapp.com',
    storageBucket: 'portfolio-b70f4.firebasestorage.app',
    measurementId: 'G-PYQXTTHJXR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJm8j_mDGI61g8-2F3DOuA-qGr-4IN-sE',
    appId: '1:286224383926:android:07980cb1306e5d29878b17',
    messagingSenderId: '286224383926',
    projectId: 'portfolio-b70f4',
    storageBucket: 'portfolio-b70f4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJm8j_mDGI61g8-2F3DOuA-qGr-4IN-sE',
    appId: '1:286224383926:ios:07980cb1306e5d29878b17',
    messagingSenderId: '286224383926',
    projectId: 'portfolio-b70f4',
    storageBucket: 'portfolio-b70f4.firebasestorage.app',
    iosBundleId: 'com.jeffanderson.portfolio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCJm8j_mDGI61g8-2F3DOuA-qGr-4IN-sE',
    appId: '1:286224383926:ios:07980cb1306e5d29878b17',
    messagingSenderId: '286224383926',
    projectId: 'portfolio-b70f4',
    storageBucket: 'portfolio-b70f4.firebasestorage.app',
    iosBundleId: 'com.jeffanderson.portfolio',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCJm8j_mDGI61g8-2F3DOuA-qGr-4IN-sE',
    appId: '1:286224383926:web:07980cb1306e5d29878b17',
    messagingSenderId: '286224383926',
    projectId: 'portfolio-b70f4',
    authDomain: 'portfolio-b70f4.firebaseapp.com',
    storageBucket: 'portfolio-b70f4.firebasestorage.app',
    measurementId: 'G-PYQXTTHJXR',
  );
}
