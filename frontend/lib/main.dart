import 'package:erp_frontend_v2/app/app.dart';
import 'package:erp_frontend_v2/boxes.dart';
import 'package:erp_frontend_v2/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  boxUser = await Hive.openBox<User>('userBox');
  runApp(
    ProviderScope(child: App()),
  );
}
