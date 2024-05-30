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
    apiKey: 'AIzaSyDUOjWLvz879vv9vLRpn64bdMuPpRLc2sY',
    appId: '1:539687966075:web:d8253501a1fd46742919de',
    messagingSenderId: '539687966075',
    projectId: 'erp-app-7974a',
    authDomain: 'erp-app-7974a.firebaseapp.com',
    storageBucket: 'erp-app-7974a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0G8CEVsHZ_tMW0EM5o-9v6XXiAMAtKmI',
    appId: '1:539687966075:android:de6004f9dd6b256f2919de',
    messagingSenderId: '539687966075',
    projectId: 'erp-app-7974a',
    storageBucket: 'erp-app-7974a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCRqgAUNWKQTEja_bCnI__61n-oVQojJsQ',
    appId: '1:539687966075:ios:5c3e10323d2b6d612919de',
    messagingSenderId: '539687966075',
    projectId: 'erp-app-7974a',
    storageBucket: 'erp-app-7974a.appspot.com',
    iosBundleId: 'com.example.erpFrontendV2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCRqgAUNWKQTEja_bCnI__61n-oVQojJsQ',
    appId: '1:539687966075:ios:5c3e10323d2b6d612919de',
    messagingSenderId: '539687966075',
    projectId: 'erp-app-7974a',
    storageBucket: 'erp-app-7974a.appspot.com',
    iosBundleId: 'com.example.erpFrontendV2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDUOjWLvz879vv9vLRpn64bdMuPpRLc2sY',
    appId: '1:539687966075:web:8a77f50c0d8e2b9d2919de',
    messagingSenderId: '539687966075',
    projectId: 'erp-app-7974a',
    authDomain: 'erp-app-7974a.firebaseapp.com',
    storageBucket: 'erp-app-7974a.appspot.com',
  );
}
