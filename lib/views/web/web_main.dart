import 'package:flutter/material.dart';
import 'email_screen.dart';
import 'home_screen.dart';
import 'codigo_screen.dart';
import 'password_screen.dart';
import 'new_password_screen.dart';

void main() {
  runApp(WebApp());
}

class WebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mecamovil',
      debugShowCheckedModeBanner: false,
      initialRoute: 'email',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == 'codigo') {
          final String email = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return CodigoScreen(email: email); // Pasando el email al constructor
            },
          );
        } else if (settings.name == 'new_password') {
          final String email = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return NewPasswordScreen(email: email); // Pasando el email al constructor
            },
          );
        } else if (settings.name == 'password') {
          final String email = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return PasswordScreen(email: email); // Pasando el email al constructor
            },
          );
        }
        return null; // Otras rutas por defecto
      },
      routes: {
        'email': (context) => EmailScreen(),
        'home': (context) => HomeScreen(),
      },
    );
  }
}

