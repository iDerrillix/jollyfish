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
    apiKey: 'AIzaSyAPBjy506cVLEt38Yo5x-FAJSXIbsFGK1k',
    appId: '1:673850109584:web:cf0dbfecda3392bcddb215',
    messagingSenderId: '673850109584',
    projectId: 'jollyfish-7593e',
    authDomain: 'jollyfish-7593e.firebaseapp.com',
    storageBucket: 'jollyfish-7593e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACVvNPJhCxIhWV-qrVoRCuHi4po7DfjaI',
    appId: '1:673850109584:android:1ab5f9055c3e8defddb215',
    messagingSenderId: '673850109584',
    projectId: 'jollyfish-7593e',
    storageBucket: 'jollyfish-7593e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCoPc2DxPoh3PGJ2otLvoibde2ebxyOGrg',
    appId: '1:673850109584:ios:6e45cc510ca784daddb215',
    messagingSenderId: '673850109584',
    projectId: 'jollyfish-7593e',
    storageBucket: 'jollyfish-7593e.appspot.com',
    iosBundleId: 'com.example.jollyfish',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCoPc2DxPoh3PGJ2otLvoibde2ebxyOGrg',
    appId: '1:673850109584:ios:b670d34e19f13dd6ddb215',
    messagingSenderId: '673850109584',
    projectId: 'jollyfish-7593e',
    storageBucket: 'jollyfish-7593e.appspot.com',
    iosBundleId: 'com.example.jollyfish.RunnerTests',
  );
}