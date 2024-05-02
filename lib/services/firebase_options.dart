// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyCcVZwRwhcV50n0MozxYRyCHuzXBMtisCg',
    appId: '1:737898149215:web:599824eea54d2806d5f2ea',
    messagingSenderId: '737898149215',
    projectId: 'creddit-by-ss-ltd',
    authDomain: 'creddit-by-ss-ltd.firebaseapp.com',
    storageBucket: 'creddit-by-ss-ltd.appspot.com',
    measurementId: 'G-N200CQ3FQ8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDie_BHxDi7iD3bjPph30mfEGFxz8om1us',
    appId: '1:737898149215:android:b8d1b2c987e1a0f4d5f2ea',
    messagingSenderId: '737898149215',
    projectId: 'creddit-by-ss-ltd',
    storageBucket: 'creddit-by-ss-ltd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcGBmz4jwtlcQa-M7R1l9JzAc0I4g3FoI',
    appId: '1:737898149215:ios:6eceb0e42d328884d5f2ea',
    messagingSenderId: '737898149215',
    projectId: 'creddit-by-ss-ltd',
    storageBucket: 'creddit-by-ss-ltd.appspot.com',
    iosBundleId: 'com.example.redditClone3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBcGBmz4jwtlcQa-M7R1l9JzAc0I4g3FoI',
    appId: '1:737898149215:ios:9f9749f897ad8070d5f2ea',
    messagingSenderId: '737898149215',
    projectId: 'creddit-by-ss-ltd',
    storageBucket: 'creddit-by-ss-ltd.appspot.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCcVZwRwhcV50n0MozxYRyCHuzXBMtisCg',
    appId: '1:737898149215:web:dd80a0575ff0ad82d5f2ea',
    messagingSenderId: '737898149215',
    projectId: 'creddit-by-ss-ltd',
    authDomain: 'creddit-by-ss-ltd.firebaseapp.com',
    storageBucket: 'creddit-by-ss-ltd.appspot.com',
    measurementId: 'G-WPNXYWYBEY',
  );

}