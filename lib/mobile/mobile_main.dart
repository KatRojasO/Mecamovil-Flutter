// lib/main.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';  // Asegúrate de que esta ruta sea correcta

void main() {
  runApp(MobileApp());
}

class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mecamovil Móvil',
      home: LoginScreen(),  // Usa LoginScreen como la pantalla principal
      // Si estás usando rutas nombradas, también podrías agregar un `initialRoute`
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => LoginScreen(),
      //   '/home': (context) => HomeScreen(), // Define HomeScreen si la tienes
      // },
    );
  }
}

