// lib/main.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';  // Asegúrate de que esta ruta sea correcta
import 'home_screen.dart';
void main() {
  runApp(MobileApp());
}
class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mecamovil',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login':(context)=>LoginScreen(),
        'home': (context) => HomeScreen(),
       // 'servicios': (context) => ServiciosScreen(),
        //'historial': (context) => HistorialScreen(),
        //'vehiculos': (context) => VehiculosScreen(),
      },
    );
  }
}


