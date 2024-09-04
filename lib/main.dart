import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'web/web_main.dart';
import 'mobile/mobile_main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb) {
    // Ejecuta la aplicación web
    runApp(WebApp());
  } else {
    // Ejecuta la aplicación móvil
    runApp(MobileApp());
  }
}
