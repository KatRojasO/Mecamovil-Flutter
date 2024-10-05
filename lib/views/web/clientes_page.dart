import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClientesPage extends StatefulWidget {
  @override
  _ClientesPageState createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  List<dynamic> usuarios = [];
  List<dynamic> usuariosFiltrados = [];
  bool isLoading = true;
  final TextEditingController _buscadorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerUsuarios();
  }

  Future<void> obtenerUsuarios() async {
    final url =
        Uri.parse('https://mecamovil.nexxosrl.site/api/obtener_usuarios.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          usuarios = json.decode(response.body);
          usuariosFiltrados =
              usuarios; // Inicialmente mostramos todos los usuarios
          isLoading = false;
        });
      } else {
        throw Exception('Error al obtener los usuarios');
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void _buscarUsuarios(String query) {
    setState(() {
      usuariosFiltrados = usuarios.where((usuario) {
        final nombre = usuario['nombre']?.toLowerCase() ?? '';
        final email = usuario['email']?.toLowerCase() ?? '';
        final telefono = usuario['telefono']?.toLowerCase() ?? '';

        return nombre.contains(query) ||
            email.contains(query) ||
            telefono.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lista de Clientes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            // Buscador
            SizedBox(
              width: 400, // Ajusta el ancho a lo que prefieras
              child: TextField(
                controller: _buscadorController,
                decoration: InputDecoration(
                  labelText: 'Buscar',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _buscarUsuarios, // Se busca directamente al escribir
              ),
            ),

            SizedBox(height: 16),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: Center(
                              child: Text(
                                'Nombre',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple, // Color del encabezado
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Center(
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple, // Color del encabezado
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Center(
                              child: Text(
                                'Teléfono',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple, // Color del encabezado
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Center(
                              child: Text(
                                'Estado',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple, // Color del encabezado
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Center(
                              child: Text(
                                'Acciones',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple, // Color del encabezado
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          //DataColumn(label: Text('Teléfono', textAlign: TextAlign.center)),
                          //DataColumn(label: Text('Acciones', textAlign: TextAlign.center)),
                        ],
                        rows: usuariosFiltrados.map((usuario) {
                          return DataRow(cells: [
                            DataCell(Text(
                              '${usuario['nombre'] ?? ''} ${usuario['apellido'] ?? ''}', // Concatenación de nombre y apellido
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold), // Estilo opcional
                            )),
                            DataCell(Text(usuario['email'] ?? '',
                                textAlign: TextAlign.center)),
                            DataCell(Text(usuario['telefono'] ?? '',
                                textAlign: TextAlign.center)),
                            DataCell(
                              Text(
                                usuario['estado'] == '1'
                                    ? 'Habilitado'
                                    : 'Deshabilitado', // Condicional para estado
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: usuario['estado'] == '1'
                                      ? Colors.green
                                      : Colors.red, // Color según el estado
                                ),
                              ),
                            ),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.visibility,
                                      color: Colors.blue),
                                  onPressed: () {
                                    _verUsuario(context, usuario);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.green),
                                  onPressed: () {
                                    _editarUsuario(context, usuario);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _eliminarUsuario(context, usuario);
                                  },
                                ),
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _verUsuario(BuildContext context, dynamic usuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles del Cliente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nombre: ${usuario['nombre']}'),
              Text('Email: ${usuario['email']}'),
              Text('Teléfono: ${usuario['telefono']}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editarUsuario(BuildContext context, dynamic usuario) {
    // editar
  }

  void _eliminarUsuario(BuildContext context, dynamic usuario) {
    // eliminar
  }
}
