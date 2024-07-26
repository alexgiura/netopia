import 'package:erp_frontend_v2/app/app.dart';
import 'package:erp_frontend_v2/boxes.dart';
import 'package:erp_frontend_v2/firebase_options.dart';
import 'package:erp_frontend_v2/models/user/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  boxUser = await Hive.openBox<User>('userBox');
  setUrlStrategy(PathUrlStrategy());

  runApp(
    ProviderScope(child: App()),
  );
}
