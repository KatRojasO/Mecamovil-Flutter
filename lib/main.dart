import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'web/web_main.dart';
import 'mobile/mobile_main.dart';

void main() {
  if (kIsWeb) {
    // Ejecuta la aplicación web
    runApp(WebApp());
  } else {
    // Ejecuta la aplicación móvil
    runApp(MobileApp());
  }
}
