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
    apiKey: 'AIzaSyBfpKmLAtRWsDvF6xtGc2kOozS6ZS6QedQ',
    appId: '1:96168103412:web:14efdc4836b638c5733da1',
    messagingSenderId: '96168103412',
    projectId: 'music-catalog-f596e',
    authDomain: 'music-catalog-f596e.firebaseapp.com',
    databaseURL: 'https://music-catalog-f596e-default-rtdb.firebaseio.com',
    storageBucket: 'music-catalog-f596e.appspot.com',
    measurementId: 'G-6ND8V1DLD5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUVn7wYxByIn9Hlzr1suPha2ufnQA7Zhk',
    appId: '1:96168103412:android:5701089cf8f248cc733da1',
    messagingSenderId: '96168103412',
    projectId: 'music-catalog-f596e',
    databaseURL: 'https://music-catalog-f596e-default-rtdb.firebaseio.com',
    storageBucket: 'music-catalog-f596e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC9YsbBK73NHLZAxNI5D7TebxTO5IZ1gyk',
    appId: '1:96168103412:ios:b0129ccdb987774d733da1',
    messagingSenderId: '96168103412',
    projectId: 'music-catalog-f596e',
    databaseURL: 'https://music-catalog-f596e-default-rtdb.firebaseio.com',
    storageBucket: 'music-catalog-f596e.appspot.com',
    iosBundleId: 'com.example.catalogoMusica',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC9YsbBK73NHLZAxNI5D7TebxTO5IZ1gyk',
    appId: '1:96168103412:ios:b0129ccdb987774d733da1',
    messagingSenderId: '96168103412',
    projectId: 'music-catalog-f596e',
    databaseURL: 'https://music-catalog-f596e-default-rtdb.firebaseio.com',
    storageBucket: 'music-catalog-f596e.appspot.com',
    iosBundleId: 'com.example.catalogoMusica',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBfpKmLAtRWsDvF6xtGc2kOozS6ZS6QedQ',
    appId: '1:96168103412:web:1e01e17d071a5001733da1',
    messagingSenderId: '96168103412',
    projectId: 'music-catalog-f596e',
    authDomain: 'music-catalog-f596e.firebaseapp.com',
    databaseURL: 'https://music-catalog-f596e-default-rtdb.firebaseio.com',
    storageBucket: 'music-catalog-f596e.appspot.com',
    measurementId: 'G-HV4PV6TW6J',
  );

}