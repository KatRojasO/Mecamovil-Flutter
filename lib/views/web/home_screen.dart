import 'package:flutter/material.dart';
import 'clientes_page.dart';
import 'servicios_page.dart';
import 'mecanicos_page.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Índice de la página seleccionada

  // Definimos las páginas para cada ítem del BottomNavigationBar
  final List<Widget> _pages = [
    HomePage(), // Pantalla de inicio
    ClientesPage(), // Pantalla de clientes
    MecanicosPage(), // Pantalla de mecánicos
    ServiciosPage(), // Pantalla de servicios
    ReportesPage(), // Pantalla de reportes
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Elimina el botón de retroceso
        backgroundColor: Colors.purple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo_navbar.png', width: 70, height: 70),
            SizedBox(width: 20),
            Text(
              'Mecamovil',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            iconSize: 50, // Aumentar el tamaño del ícono de perfil
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              // Acción para perfil
            },
          ),
        ],
      ),
      body: _pages[_currentIndex], // Renderiza la página según el índice actual
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Índice de la página actual
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Cambia el índice cuando se selecciona un ítem
          });
        },
        selectedItemColor: Colors.purple, // Color para el ítem seleccionado
        unselectedItemColor: Colors.grey, // Color para los ítems no seleccionados
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Mecánicos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services),
            label: 'Servicios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Reportes',
          ),
        ],
      ),
    );
  }
}

// Páginas de ejemplo para cada ítem del BottomNavigationBar
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Página de Inicio'),
    );
  }
}



/*
class ServiciosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Página de Servicios'),
    );
  }
}
*/
class ReportesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Página de Reportes'),
    );
  }
}
