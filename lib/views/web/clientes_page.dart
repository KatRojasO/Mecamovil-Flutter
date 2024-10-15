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
  int _rowsPerPage = 5;

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
          usuariosFiltrados = usuarios;
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
          SizedBox(
            width: 400,
            child: TextField(
              controller: _buscadorController,
              decoration: InputDecoration(
                labelText: 'Buscar',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _buscarUsuarios,
            ),
          ),
          SizedBox(height: 16),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(  // Cambiamos por Expanded para manejar el tamaño dinámico
                  child: SingleChildScrollView(
                
                    
                      child: PaginatedDataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              'N°',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Nombre',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Email',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Teléfono',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Estado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Acciones',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ],
                        source: UsuarioDataSource(
                          usuariosFiltrados, context, actualizarEstado, () {
                            setState(() {});
                          }
                        ),
                        rowsPerPage: _rowsPerPage,
                        columnSpacing: 10,
                      ),
                    ),
                  ),
                
        ],
      ),
    ),
  );
}

  Future<bool> actualizarEstado(int id, int nuevoEstado) async {
    final url =
        Uri.parse('https://mecamovil.nexxosrl.site/api/actualizar_estado.php');

    final response = await http.post(
      url,
      body: {
        'id': id.toString(),
        'nuevo_estado': nuevoEstado.toString(),
      },
    );

    if (response.statusCode == 200) {
      var respuesta = json.decode(response.body);
      return respuesta['success'] == true;
    } else {
      return false;
    }
  }
}

class UsuarioDataSource extends DataTableSource {
  final List<dynamic> usuarios;
  final BuildContext context;
  final Future<bool> Function(int id, int nuevoEstado) actualizarEstado;
  final VoidCallback onActualizarEstado; // para llamar a setState

  UsuarioDataSource(
    this.usuarios,
    this.context,
    this.actualizarEstado,
    this.onActualizarEstado,
  );

  @override
  DataRow getRow(int index) {
    final usuario = usuarios[index];

    return DataRow(cells: [
      DataCell(Container(
        width: 50,
        child: Text('${index + 1}'),
      )),
      DataCell(Container(
        width: 400, // Ancho 
        child: Text(
          '${usuario['nombre'] ?? ''} ${usuario['apellido'] ?? ''}'.toUpperCase(), 
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )),
      DataCell(Container(
        width: 300, // Ancho
        child: Text(usuario['email'] ?? ''),
      )),
      DataCell(Container(
        width: 150, // Ancho
        child: Text(usuario['telefono'] ?? ''),
      )),
      DataCell(
        Container(
          width: 150,
          child: TextButton(
          onPressed: () async {
            int estadoActual = int.parse(usuario['estado']);
            if (estadoActual == 1) {
              estadoActual = 0;
            } else {
              estadoActual = 1;
            }

            bool actualizado =
                await actualizarEstado(int.parse(usuario['id']), estadoActual);
            if (actualizado) {
              usuario['estado'] = estadoActual.toString();
              onActualizarEstado(); // Llama al callback
            }
          },
          style: TextButton.styleFrom(
            backgroundColor:
                usuario['estado'] == '1' ? Colors.green : Colors.red,
          ),
          child: Text(
            usuario['estado'] == '1' ? 'Habilitado' : 'Deshabilitado',
            style: TextStyle(color: Colors.white),
          ),
        ),
        )
      ),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.visibility, color: Colors.blue),
              onPressed: () {
                // Implementar la acción de ver detalles
              },
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.green),
              onPressed: () {
                // Implementar la acción de editar
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Implementar la acción de eliminar
              },
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => usuarios.length;

  @override
  int get selectedRowCount => 0;
}
