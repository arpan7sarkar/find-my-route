import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'Enter your api key here',
    authDomain: 'find-my-bus-77f98.firebaseapp.com',
    projectId: 'find-my-bus-77f98',
    storageBucket: 'find-my-bus-77f98.firebasestorage.app',
    messagingSenderId: '145122191490',
    appId: '1:145122191490:web:8a087f1bf606b7d55cac9b',
    measurementId: 'G-C9MBL2SM02',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'Enter your api key here',
    authDomain: 'find-my-bus-77f98.firebaseapp.com',
    projectId: 'find-my-bus-77f98',
    storageBucket: 'find-my-bus-77f98.firebasestorage.app',
    messagingSenderId: '145122191490',
    appId: '1:145122191490:android:8a087f1bf606b7d55cac9b',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'Enter your api key here',
    authDomain: 'find-my-bus-77f98.firebaseapp.com',
    projectId: 'find-my-bus-77f98',
    storageBucket: 'find-my-bus-77f98.firebasestorage.app',
    messagingSenderId: '145122191490',
    appId: '1:145122191490:ios:8a087f1bf606b7d55cac9b',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'Enter your api key here',
    authDomain: 'find-my-bus-77f98.firebaseapp.com',
    projectId: 'find-my-bus-77f98',
    storageBucket: 'find-my-bus-77f98.firebasestorage.app',
    messagingSenderId: '145122191490',
    appId: '1:145122191490:macos:8a087f1bf606b7d55cac9b',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'Enter your api key here',
    authDomain: 'find-my-bus-77f98.firebaseapp.com',
    projectId: 'find-my-bus-77f98',
    storageBucket: 'find-my-bus-77f98.firebasestorage.app',
    messagingSenderId: '145122191490',
    appId: '1:145122191490:windows:8a087f1bf606b7d55cac9b',
  );
}