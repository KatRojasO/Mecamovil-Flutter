import 'package:flutter/material.dart';
import 'package:mecamovil/models/usuario_model.dart';
import 'package:mecamovil/controllers/usuario_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart'; // Para obtener los datos de Firebase

class VehiculosScreen extends StatefulWidget {
  @override
  _VehiculosScreenState createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  List<dynamic> vehiculos = [];
  bool isLoading = true;
  String? userEmail;

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
  


  Future<void> obtenerVehiculos(String emailUsuario) async {
    final url = Uri.parse('https://mecamovil.nexxosrl.site/api/obtener_vehiculos.php');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': emailUsuario,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          vehiculos = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Error al obtener los vehículos');
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void _mostrarVehiculosDetallados(Map<String, String> vehiculo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalles del Vehículo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(vehiculo['foto']!),
              SizedBox(height: 30),
              Text('Marca: ${vehiculo['marca']}'),
              Text('Modelo: ${vehiculo['modelo']}'),
              Text('Tipo: ${vehiculo['tipo']}'),
              Text('Cilindrada: ${vehiculo['cilindrada']}'),
              Text('Placa: ${vehiculo['placa']}'),
              Text('Color: ${vehiculo['color']}'),
              Text('Combustible: ${vehiculo['combustible']}'),
              Text('Tipo Motor: ${vehiculo['tipo_motor']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
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
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 30,
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
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, 'home');
              },
            ),
            ListTile(
              leading: Icon(Icons.build),
              title: Text('Servicios'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Historial'),
              onTap: () {},
            ),
            ListTile(
              leading: Image.asset(
                'assets/logo_vehiculos.png',
                width: 30,
                height: 30,
              ),
              title: Text('Vehículos'),
              onTap: () {
                Navigator.pushNamed(context, 'vehiculos');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {},
            ),
            SizedBox(height: 200),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  print("Modo Mecánico activado");
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.purple,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vehículos Registrados',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Aquí iría la lógica para agregar un nuevo vehículo
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7, // proporcion tarjetas
                      ),
                      itemCount: vehiculos.length,
                      itemBuilder: (context, index) {
                        final vehiculo = vehiculos[index];
                        return GestureDetector(
                          onTap: () => _mostrarVehiculosDetallados(vehiculo),
                          child: Card(
                            elevation: 4,
                            child: Column(
                              children: [
                                Image.network(
                                  vehiculo['foto']!,
                                  width: double.infinity,
                                  height: 150, // altura de la imagen
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${vehiculo['clase_vehiculo']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('Marca: ${vehiculo['marca']}', style: TextStyle(fontSize: 18)),
                                      Text('Placa: ${vehiculo['placa']}', style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
