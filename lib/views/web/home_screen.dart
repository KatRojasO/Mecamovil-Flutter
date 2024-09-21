import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Esto elimina el botón de retroceso
        backgroundColor: Colors.purple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo_navbar.png', width: 70, height: 70),
            SizedBox(width: 20),
            Text(
              'Mecamovil',
              style: TextStyle(color: Colors.white), // Texto blanco
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            iconSize: 50, // Aumentar el tamaño del ícono de sesión
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              // Acción para perfil
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, 'home');
                },
                icon: Icon(Icons.home, color: Colors.white),
                label: Text(
                  'Inicio',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 20),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/clientes');
                },
                icon: Icon(Icons.people, color: Colors.white),
                label: Text(
                  'Clientes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 20),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/mecanicos');
                },
                icon: Icon(Icons.build, color: Colors.white),
                label: Text(
                  'Mecánicos',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 20),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/servicios');
                },
                icon: Icon(Icons.miscellaneous_services, color: Colors.white),
                label: Text(
                  'Servicios',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 20),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/reportes');
                },
                icon: Icon(Icons.report, color: Colors.white),
                label: Text(
                  'Reportes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Inicio', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCard(context, "Compras del mes", "\$12.500,00", Icons.shopping_bag, Colors.blue),
                _buildCard(context, "Compras del año", "\$12.500,00", Icons.show_chart, Colors.black),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCard(context, "Ventas del mes", "\$12.500,00", Icons.shopping_cart, Colors.teal),
                _buildCard(context, "Ventas del año", "\$12.500,00", Icons.line_style, Colors.green),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Compras y ventas mensuales', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Container(
                                color: Colors.grey[200],
                                // Aquí irá el gráfico
                                child: Center(child: Text('Gráfico 1')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Compras y ventas anuales', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Container(
                                color: Colors.grey[200],
                                // Aquí irá el gráfico
                                child: Center(child: Text('Gráfico 2')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String amount, IconData icon, Color color) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amount,
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    title,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              Icon(icon, color: Colors.white, size: 50),
            ],
          ),
        ),
      ),
    );
  }
}
