import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final String nombreCliente = "Nombre del Cliente"; // Nombre del cliente a ser obtenido
  final String urlFotoCliente = "https://via.placeholder.com/150"; // URL de la foto del cliente

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mecamovil'),
        backgroundColor: Colors.purple,
        // Este botón ya está configurado para abrir el Drawer
        automaticallyImplyLeading: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Text(
                'Opciones',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.car_repair),
              title: Text('Servicios'),
              onTap: () {
                // Navegar a la pantalla de Servicios
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Historial'),
              onTap: () {
                // Navegar a la pantalla de Historial
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Vehículos'),
              onTap: () {
                // Navegar a la pantalla de Vehículos
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                // Navegar a la pantalla de Configuración
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(urlFotoCliente), // Cargar la foto del cliente
            ),
            SizedBox(height: 16),
            Text(
              '¡Bienvenido, $nombreCliente!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
