import 'package:flutter/material.dart';

void main() {
  runApp(MobileApp());
}

class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mecamovil Móvil',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mecamovil Móvil'),
        ),
        body: Center(
          child: Text('Bienvenido, cliente o mecánico.'),
        ),
      ),
    );
  }
}
