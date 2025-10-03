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
    apiKey: 'AIzaSyDJytlr2Df-u08ma_uePBHqVTN_XojjpHg',
    appId: '1:206356076885:web:225e9b679f7b057289b7dc',
    messagingSenderId: '206356076885',
    projectId: 'task-flow-b8217',
    authDomain: 'task-flow-b8217.firebaseapp.com',
    storageBucket: 'task-flow-b8217.firebasestorage.app',
    measurementId: 'G-929QFRZHBM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA2CuSTiIV9Q5iVpb4LPLhGSUyVVa6jtvM',
    appId: '1:206356076885:android:cdef7d3f905a11e989b7dc',
    messagingSenderId: '206356076885',
    projectId: 'task-flow-b8217',
    storageBucket: 'task-flow-b8217.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJ7IELUffTEqyQ_w_9iLltl2piklGmOTs',
    appId: '1:206356076885:ios:79bcee208031ec9989b7dc',
    messagingSenderId: '206356076885',
    projectId: 'task-flow-b8217',
    storageBucket: 'task-flow-b8217.firebasestorage.app',
    iosBundleId: 'com.example.taskFlow',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBJ7IELUffTEqyQ_w_9iLltl2piklGmOTs',
    appId: '1:206356076885:ios:79bcee208031ec9989b7dc',
    messagingSenderId: '206356076885',
    projectId: 'task-flow-b8217',
    storageBucket: 'task-flow-b8217.firebasestorage.app',
    iosBundleId: 'com.example.taskFlow',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDJytlr2Df-u08ma_uePBHqVTN_XojjpHg',
    appId: '1:206356076885:web:225e9b679f7b057289b7dc',
    messagingSenderId: '206356076885',
    projectId: 'task-flow-b8217',
    authDomain: 'task-flow-b8217.firebaseapp.com',
    storageBucket: 'task-flow-b8217.firebasestorage.app',
    measurementId: 'G-929QFRZHBM',
  );
}
