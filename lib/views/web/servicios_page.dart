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

  void _mostrarDialogoAgregarServicio() {
    final TextEditingController servicioController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Servicio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 500, // Ajusta el ancho del input
                height: 60, // Ajusta la altura del input
                child: TextField(
                  controller: servicioController,
                  decoration: InputDecoration(
                    labelText: 'Servicio',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 500, // Ajusta el ancho del input
                height: 60, // Ajusta la altura del input
                child: TextField(
                  controller: descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5, // Permitir varias líneas para la descripción
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                String nuevoServicio = servicioController.text;
                String nuevaDescripcion = descripcionController.text;

                if (nuevoServicio.isNotEmpty && nuevaDescripcion.isNotEmpty) {
                  // Llamar a la función para agregar el nuevo servicio
                  bool exito = await _agregarNuevoServicio(
                    nuevoServicio,
                    nuevaDescripcion,
                  );

                  if (exito) {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                    obtenerServicios(); // Actualizar la lista de servicios
                  }
                }
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  // Función para agregar el nuevo servicio a la base de datos
  Future<bool> _agregarNuevoServicio(
      String servicio, String descripcion) async {
    final url =
        Uri.parse('https://mecamovil.nexxosrl.site/api/agregar_servicio.php');

    try {
      final response = await http.post(
        url,
        body: {
          'servicio': servicio,
          'descripcion': descripcion,
        },
      );

      if (response.statusCode == 200) {
        var respuesta = json.decode(response.body);
        return respuesta['success'] == true;
      } else {
        throw Exception('Error al agregar servicio');
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
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
        
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, 
              children: [
             
                Expanded(
                  child: SizedBox(
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
                ),

                SizedBox(width: 800), // Espacio entre el buscador y el botón

             
                ElevatedButton.icon(
                  onPressed: _mostrarDialogoAgregarServicio,
                  icon: Icon(Icons.add, color: Colors.white), // Ícono de "+"
                  label: Text('Agregar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Color verde del botón
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                    foregroundColor: Colors.white, // Color del texto
                  ),
                ),
              ],
            ),

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
        width: 250, // Ancho
        child: Text(
          '${servicio['servicio'] ?? ''}'.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )),
      DataCell(Container(
        width: 800, // Ancho
        child: Text(servicio['descripcion'] ?? ''),
      )),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.green),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditarServicioPage(
                      servicio: servicio, // Pasamos el servicio actual
                      onServicioEditado: () {
                        onActualizarEstado(); // Refresca la lista después de editar
                      },
                    ),
                  ),
                );
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

class EditarServicioPage extends StatefulWidget {
  final Map<String, dynamic> servicio;
  final VoidCallback onServicioEditado;

  EditarServicioPage({required this.servicio, required this.onServicioEditado});

  @override
  _EditarServicioPageState createState() => _EditarServicioPageState();
}

class _EditarServicioPageState extends State<EditarServicioPage> {
  late TextEditingController _servicioController;
  late TextEditingController _descripcionController;

  @override
  void initState() {
    super.initState();
    _servicioController =
        TextEditingController(text: widget.servicio['servicio']);
    _descripcionController =
        TextEditingController(text: widget.servicio['descripcion']);
  }

  Future<void> _guardarCambios() async {
    final url =
        Uri.parse('https://mecamovil.nexxosrl.site/api/editar_servicio.php');

    final response = await http.post(
      url,
      body: {
        'id': widget.servicio['id'].toString(),
        'servicio': _servicioController.text,
        'descripcion': _descripcionController.text,
      },
    );

    if (response.statusCode == 200) {
      var respuesta = json.decode(response.body);
      if (respuesta['success']) {
        widget.onServicioEditado();
        Navigator.pop(context); // Cerrar la pantalla de edición
      } else {
        print('Error al editar el servicio');
      }
    } else {
      print('Error en la petición');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Servicio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _servicioController,
              decoration: InputDecoration(labelText: 'Servicio'),
            ),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
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
