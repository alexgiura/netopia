import 'package:erp_frontend_v2/app/app.dart';
import 'package:erp_frontend_v2/boxes.dart';
import 'package:erp_frontend_v2/firebase_options.dart';
import 'package:erp_frontend_v2/routing/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:erp_frontend_v2/models/user/user.dart' as custom_user;

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await Hive.initFlutter();
  // Hive.registerAdapter(custom_user.UserAdapter());
  // boxUser = await Hive.openBox<User>('userBox');
  setUrlStrategy(PathUrlStrategy());
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    router.refresh();
  });

  runApp(
    ProviderScope(child: App()),
  );
}
