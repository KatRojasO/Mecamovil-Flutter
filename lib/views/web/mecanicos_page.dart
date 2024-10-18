import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MecanicosPage extends StatefulWidget {
  @override
  _MecanicosPageState createState() => _MecanicosPageState();
}

class _MecanicosPageState extends State<MecanicosPage> {
  List<dynamic> mecanicos = [];
  List<dynamic> mecanicosFiltrados = [];
  bool isLoading = true;
  final TextEditingController _buscadorController = TextEditingController();
  int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    obtenerMecanicos();
  }

  Future<void> obtenerMecanicos() async {
    final url =
        Uri.parse('https://mecamovil.nexxosrl.site/api/obtener_mecanicos.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          mecanicos = json.decode(response.body);
          mecanicosFiltrados = mecanicos;
          isLoading = false;
        });
      } else {
        throw Exception('Error al obtener los mecánicos');
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void _buscarMecanicos(String query) {
    setState(() {
      mecanicosFiltrados = mecanicos.where((mecanico) {
        final nombre = mecanico['nombre']?.toLowerCase() ?? '';
        final email = mecanico['email']?.toLowerCase() ?? '';
        final telefono = mecanico['telefono']?.toLowerCase() ?? '';

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
              'Lista de Mecánicos',
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
                onChanged: _buscarMecanicos,
              ),
            ),
            SizedBox(height: 16),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
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
                              'Saldo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Estado Saldo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Editar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ],
                        source: MecanicoDataSource(
                            mecanicosFiltrados, context, actualizarEstado, () {
                           obtenerMecanicos();
                        }),
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

class MecanicoDataSource extends DataTableSource {
  final List<dynamic> mecanicos;
  final BuildContext context;
  final Future<bool> Function(int id, int nuevoEstado) actualizarEstado;
  final VoidCallback onActualizarEstado;
  MecanicoDataSource(
    this.mecanicos,
    this.context,
    this.actualizarEstado,
    this.onActualizarEstado,
  );

  @override
  DataRow getRow(int index) {
    final mecanico = mecanicos[index];

    return DataRow(cells: [
      DataCell(Container(
        width: 20,
        child: Text('${index + 1}'),
      )),
      DataCell(Container(
        width: 400, // Ancho
        child: Text(
          '${mecanico['nombre'] ?? ''} ${mecanico['apellido'] ?? ''}'
              .toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )),
      DataCell(Container(
        width: 250, // Ancho
        child: Text(mecanico['email'] ?? ''),
      )),
      DataCell(Container(
        width: 100, // Ancho
        child: Text(mecanico['telefono'] ?? ''),
      )),
      DataCell(
        Container(
          width: 120,
          child: TextButton(
          onPressed: () async {
            int estadoActual = int.parse(mecanico['estado']);
            if (estadoActual == 1) {
              estadoActual = 0;
            } else {
              if(estadoActual==0){
                estadoActual = 1;
              }
              else{
                estadoActual = 2;
              }
            }
            bool actualizado =
                await actualizarEstado(int.parse(mecanico['id']), estadoActual);
            if (actualizado) {
              mecanico['estado'] = estadoActual.toString();
              onActualizarEstado(); // Llama al callback
            }
          },
          style: TextButton.styleFrom(
            backgroundColor:
                mecanico['estado'] == '1' ? Colors.green : (mecanico['estado'] == '2' ? Colors.yellow : Colors.red),
          ),
          child: Text(
            mecanico['estado'] == '1' ? 'Habilitado' : (mecanico['estado'] == '2' ? 'Pendiente': 'Deshabilitado'),
            style: TextStyle(color: Colors.white),
          ),
        ),
        )
      ),
      DataCell(Container(
        width: 80,
        
        child: Text(
          '${mecanico['saldo'] ?? '0'} Bs.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )),
      DataCell(
        Container(
          width: 100,
          height: 30,
          padding: EdgeInsets.symmetric(vertical: 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                mecanico['estado_saldo'] == '1' ? Colors.green : Colors.yellow,
            borderRadius:
                BorderRadius.circular(40), 
          ),
          child: Text(
            mecanico['estado_saldo'] == '1' ? 'Normal' : 'Pendiente',
            style: TextStyle(color: Colors.white), 
          ),
        ),
      ),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*
            IconButton(
              icon: Icon(Icons.visibility, color: Colors.blue),
              onPressed: () {
                // Implementar la acción de ver detalles
              },
            ),*/
            IconButton(
              icon: Icon(Icons.edit, color: Colors.green),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditarMecanicoPage(
                      mecanico: mecanico, // Pasamos el servicio actual
                      onMecanicoEditado: () {
                        onActualizarEstado(); // Refresca la lista después de editar
                      },
                    ),
                 
                ),
                );
              },
            ),
            /*
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Implementar la acción de eliminar
              },
            ),*/
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => mecanicos.length;

  @override
  int get selectedRowCount => 0;
}
class EditarMecanicoPage extends StatefulWidget {
  final Map<String, dynamic> mecanico;
  final VoidCallback onMecanicoEditado;

  EditarMecanicoPage({required this.mecanico, required this.onMecanicoEditado});

  @override
  _EditarMecanicoPageState createState() => _EditarMecanicoPageState();
}

class _EditarMecanicoPageState extends State<EditarMecanicoPage> {
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;

  @override
  void initState() {
    super.initState();
    _nombreController =
        TextEditingController(text: widget.mecanico['nombre']);
    _apellidoController =
        TextEditingController(text: widget.mecanico['apellido']);
        _emailController =
        TextEditingController(text: widget.mecanico['email']);
        _telefonoController =
        TextEditingController(text: widget.mecanico['telefono']);
  }

  Future<void> _guardarCambios() async {
    final url =
        Uri.parse('https://mecamovil.nexxosrl.site/api/actualizar_usuario.php');

    final response = await http.post(
      url,
      body: {
        'id': widget.mecanico['id'].toString(),
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'email': _emailController.text,
        'telefono': _telefonoController.text,
      },
    );

    if (response.statusCode == 200) {
      var respuesta = json.decode(response.body);
      if (respuesta['success']) {
        widget.onMecanicoEditado();
        Navigator.pop(context); 
      } else {
        print('Error al editar el mecanico');
      }
    } else {
      print('Error en la petición');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Mecánico')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidoController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _telefonoController,
              decoration: InputDecoration(labelText: 'Telefono'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarCambios,
              child: Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
