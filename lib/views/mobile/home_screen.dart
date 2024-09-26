import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/usuario_model.dart';
import '../../controllers/usuario_controller.dart';
import 'editar_usuario.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Usuario? usuario;

  @override
  void initState() {
    super.initState();
    //Email del usuario actual desde Firebase
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fetchUsuario(user.email!).then((usuarioData) {
        setState(() {
          usuario = usuarioData;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 65),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mecamovil',
                    style: TextStyle(
                      color: Colors.white, // Color del texto
                      fontSize: 24, // Tamaño de la fuente
                      fontWeight: FontWeight.bold, // Grosor de la fuente
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(
          color: Colors.white, // Color blanco
          size: 30, // Tamaño del icono más grande
        ),
        automaticallyImplyLeading: true,
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Center(
                child: Image.asset(
                  'assets/logo_navbar.png',
                  fit: BoxFit
                      .cover, // Ajusta la imagen para cubrir todo el espacio del DrawerHeader
                ),
              ),
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(
                    context, 'home'); // Navega a la pantalla de Servicios
              },
            ),
            ListTile(
              leading: Icon(Icons.build),
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
              leading: Image.asset(
                'assets/logo_vehiculos.png', // Ícono personalizado para Vehículos
                width: 30,
                height: 30,
              ),
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
            SizedBox(height: 200), // Espacio antes del botón
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Acción al presionar "Modo Mecánico"
                  print("Modo Mecánico activado");
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.purple, // Color del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Modo Mecánico',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: usuario == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                        usuario!.url_foto ?? "https://via.placeholder.com/150"),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '¡Bienvenid@, ${usuario!.nombre}!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Nombre:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 40),
                            Expanded(
                              child: Text(
                                '${usuario!.nombre}'+' '+'${usuario!.apellido}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal, // Sin negrita
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Correo:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 40),
                            Expanded(
                              child: Text(
                                '${usuario!.email}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal, // Sin negrita
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Teléfono:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 40),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${usuario!.telefono ?? ''}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.normal, // Sin negrita
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarUsuarioScreen(usuario: usuario!), 
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.purple, // Color del botón
    foregroundColor: Colors.white,  // Color del texto del botón
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    textStyle: TextStyle(fontSize: 18),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  child: Text('Editar datos'),
),

                ],
              ),
            ),
    );
  }
}
