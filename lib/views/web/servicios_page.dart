import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServiciosPage extends StatefulWidget {
  @override
  _ServiciosPageState createState() => _ServiciosPageState();
}

class _ServiciosPageState extends State<ServiciosPage> {
  List<dynamic> servicios = [];
  List<dynamic> serviciosFiltrados = [];
  bool isLoading = true;
  final TextEditingController _buscadorController = TextEditingController();
  int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    obtenerServicios();
  }

  Future<void> obtenerServicios() async {
    final url =
        Uri.parse('https://mecamovil.nexxosrl.site/api/obtener_servicios.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          servicios = json.decode(response.body);
          serviciosFiltrados = servicios;
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

  void _buscarServicios(String query) {
    setState(() {
      serviciosFiltrados = servicios.where((servicio) {
        final nombre_servicio = servicio['servicio']?.toLowerCase() ?? '';

        return nombre_servicio.contains(query);
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
              'Lista de Servicios',
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
                onChanged: _buscarServicios,
              ),
            ),
            SizedBox(height: 16),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    // Cambiamos por Expanded para manejar el tamaño dinámico
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
                              'Servicio',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Descripcion',
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
                        source: ServicioDataSource(
                            serviciosFiltrados, context, actualizarEstado, () {
                          obtenerServicios();
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
    final url = Uri.parse(
        'https://mecamovil.nexxosrl.site/api/actualizar_estado_servicio.php');

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

class ServicioDataSource extends DataTableSource {
  final List<dynamic> servicios;
  final BuildContext context;
  final Future<bool> Function(int id, int nuevoEstado) actualizarEstado;
  final VoidCallback onActualizarEstado; // para llamar a setState

  ServicioDataSource(
    this.servicios,
    this.context,
    this.actualizarEstado,
    this.onActualizarEstado,
  );

  @override
  DataRow getRow(int index) {
    final servicio = servicios[index];

    return DataRow(cells: [
      DataCell(Container(
        width: 50,
        child: Text('${index + 1}'),
      )),
      DataCell(Container(
        width: 300, // Ancho
        child: Text(
          '${servicio['servicio'] ?? ''}'.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )),
      DataCell(Container(
        width: 700, // Ancho
        child: Text(servicio['descripcion'] ?? ''),
      )),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            IconButton(
              icon: Icon(Icons.edit, color: Colors.green),
              onPressed: () {
                // Implementar la acción de editar
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                bool actualizado =
                    await actualizarEstado(int.parse(servicio['id']), 0);
                if (actualizado) {
                  servicio['estado'] = 0.toString();
                  onActualizarEstado(); // Llama al callback
                }
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
  int get rowCount => servicios.length;

  @override
  int get selectedRowCount => 0;
}
