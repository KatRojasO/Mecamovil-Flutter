// lib/main.dart
import 'package:flutter/material.dart';
import 'package:mecamovil/views/mobile/solicitudes/crear_solicitud_screen.dart';
import 'login_screen.dart';  // Asegúrate de que esta ruta sea correcta
import 'home_screen.dart';
import 'vehiculos_screen.dart';
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
        'vehiculos': (context) => VehiculosScreen(),
        'solicitud': (context) => CrearSolicitudScreen(),
        //'historial': (context) => HistorialScreen(),
        //'vehiculos': (context) => VehiculosScreen(),
      },
    );
  }
}


