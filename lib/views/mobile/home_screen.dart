import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mecamovil/views/mobile/layouts/menu.dart';
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
        title: const Row(
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
        iconTheme: const IconThemeData(
          color: Colors.white, // Color blanco
          size: 30, // Tamaño del icono más grande
        ),
        automaticallyImplyLeading: true,
      ),
      drawer: Menu(),
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
                    style: const TextStyle(
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
                        const Row(
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
                                    style: const TextStyle(
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
