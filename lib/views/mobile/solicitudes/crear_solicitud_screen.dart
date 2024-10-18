import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mecamovil/controllers/servicio_controller.dart';
import 'package:mecamovil/controllers/solicitud_asistencia_controller.dart';
import 'package:mecamovil/controllers/vehiculo_controller.dart';
import 'package:mecamovil/models/solicitud_asistencia_model.dart';
import 'package:mecamovil/models/vehiculo_model.dart';
import 'package:mecamovil/views/mobile/solicitudes/propuestas_solicitud_screen.dart';
import 'package:session_storage/session_storage.dart';
import '../layouts/menu.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

const MAPBOX_ACCESS_TOKEN = "pk.eyJ1Ijoia2V2aW5jaG85NCIsImEiOiJjbTI5eWtzamswMmNvMnBxMnc2MWo3bmlxIn0.q75ivDjG_oBFsTxhybuogg";

class CrearSolicitudScreen extends StatefulWidget {
  const CrearSolicitudScreen({super.key});
  
  @override
  State<CrearSolicitudScreen> createState() => _CrearSolicitudScreenState();
}

class _CrearSolicitudScreenState extends State<CrearSolicitudScreen> {
  LatLng? _miPosicion;

  late int _idCliente;
  late int _servicioSeleccionado;
  late TextEditingController _detalleController;
  late int _pagoSelecionado;
  late TextEditingController _precioController;
  late int _idVehiculo = 0;
  final _formKey = GlobalKey<FormState>();
  final session = SessionStorage();

  List<Vehiculo> _listaVehiculos = [];

  List<Widget> _servicios = <Widget> [];
  List<bool> _selectedServicios = <bool>[];
  List<int> _idServicios = <int>[];
  
  List<Widget> pagos = <Widget> [
    Text('Efectivo'),
    Text('QR'),
  ];
  final List<bool> _selectedPagos = <bool>[true, false];

  Future<bool> permisosGPS() async {
    LocationPermission permisos;
    permisos = await Geolocator.checkPermission();
    if (permisos == LocationPermission.denied) {
      permisos = await Geolocator.requestPermission();
      return true;
    } 
    if (permisos == LocationPermission.whileInUse) {
      return true;
    }
    return false;
  }

  Future<void> obtenerUbicacion() async {
    bool permisos = await permisosGPS();
    if (permisos) {
      Position posicion = await Geolocator.getCurrentPosition();
      setState(() {
        _miPosicion = LatLng(posicion.latitude, posicion.longitude);
      });
    }
    _miPosicion =LatLng(-17.387942, -66.151740);
  }


  @override
  void initState() {
    obtenerUbicacion();
    super.initState();

    _idCliente = 4;
    _detalleController = TextEditingController(text: "");
    _precioController = TextEditingController(text: "");

    String userEmail = session['userEmail']!;

    //Lista de Vehiculos del usuario
    obtenerVehiculos(userEmail).then((listaVehiculos) {
      setState(() {
        _listaVehiculos = listaVehiculos;
        _idVehiculo = listaVehiculos[0].id;
      });
    });

    //Lista de Servicios
    obtenerServicios().then((listaServicios) {
      setState(() {
        for (var servicio in listaServicios) {
          _servicios.add(Text(servicio.servicio));
          _idServicios.add(servicio.id);
          _selectedServicios.add(false);
        }
        _selectedServicios[0] = true;
      });
    });

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
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
        automaticallyImplyLeading: true,
      ),
      drawer: const Menu(),
      body: _miPosicion == null ? const Center(child: CircularProgressIndicator()):
        SingleChildScrollView(
          child:
            Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height - 506,
                      child:
                        FlutterMap(
                          options: MapOptions(
                            initialCenter: _miPosicion!,
                            minZoom: 5,
                            maxZoom: 25,
                            initialZoom: 18
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                              additionalOptions: {
                                'accessToken': MAPBOX_ACCESS_TOKEN,
                                'id': 'mapbox/streets-v12'
                              },
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _miPosicion!, 
                                  child: const Icon(
                                    Icons.pin_drop_sharp,
                                    color: Colors.purple,
                                    size: 40,
                                  )
                                ),
                              ]),
                          ],
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child:
                          Column(
                            children: [
                              const SizedBox(height: 20),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'El campo es obligatorio';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(labelText: 'Ubicacion* (Latitud, Longitud)'),
                                initialValue: '${_miPosicion!.latitude}, ${_miPosicion!.longitude}',
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(
                                width: double.infinity,
                                child: Text("Servicios", textAlign: TextAlign.left,style: TextStyle(color: Colors.deepPurple, fontSize: 12),),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ToggleButtons(
                                  direction: Axis.horizontal,
                                  onPressed: (int index) {
                                    setState(() {
                                      for (int i = 0; i < _selectedServicios.length; i++) {
                                        _selectedServicios[i] = i == index;
                                      }
                                      _servicioSeleccionado = index;
                                    });
                                  },
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  selectedBorderColor: Colors.purple[700],
                                  selectedColor: Colors.white,
                                  fillColor: Colors.purple[300],
                                  color: Colors.purple[400],
                                  constraints: const BoxConstraints(
                                    minHeight: 40.0,
                                    minWidth: 80.0,
                                  ),
                                  isSelected: _selectedServicios,
                                  children: _servicios,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'El campo es obligatorio';
                                  }
                                  return null;
                                },
                                controller: _detalleController,
                                decoration: const InputDecoration(labelText: 'Detalle*'),
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(
                                width: double.infinity,
                                child: Text("Pago", textAlign: TextAlign.left,style: TextStyle(color: Colors.deepPurple, fontSize: 12),),
                              ),
                              ToggleButtons(
                                direction: Axis.horizontal,
                                onPressed: (int index) {
                                  setState(() {
                                    for (int i = 0; i < _selectedPagos.length; i++) {
                                      _selectedPagos[i] = i == index;
                                    }
                                    _pagoSelecionado = index;
                                  });
                                },
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                selectedBorderColor: Colors.purple[700],
                                selectedColor: Colors.white,
                                fillColor: Colors.purple[300],
                                color: Colors.purple[400],
                                constraints: const BoxConstraints(
                                  minHeight: 40.0,
                                  minWidth: 80.0,
                                ),
                                isSelected: _selectedPagos,
                                children: pagos,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'El campo es obligatorio';
                                  }
                                  return null;
                                },
                                controller: _precioController,
                                decoration: const InputDecoration(labelText: 'Precio*'),
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField(
                                value: _idVehiculo,
                                decoration: const InputDecoration(labelText: 'Clase*'),
                                items: _listaVehiculos.map((e) {
                                  return DropdownMenuItem(
                                    value: e.id,
                                    child: Text('${e.clase_vehiculo} - ${e.placa}'),
                                  );
                                }).toList(), 
                                onChanged: (value) {
                                  setState(() {
                                    _idVehiculo = value!;
                                  });
                                }
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Procesando la información...')),
                                    );
                                  }

                                  guardar_datos();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple, // Fondo
                                  foregroundColor: Colors.white, // Texto
                                ),
                                child: const Text('Solicitar'),
                              ),
                            ],
                          ),
                      ),
                    ),
                    
                  ],
                ),
              ],
            ),
        ),
        
      );
  }

  void guardar_datos() async {
    Solicitud_Asistencia solicitud = Solicitud_Asistencia(
      id: 0, 
      cliente_id: _idCliente,
      mecanico_id: 0, 
      vehiculo_id: _idVehiculo, 
      descripcion_problema: _detalleController.text, 
      estado: "pendiente", 
      fecha_solicitud: DateTime.now(), 
      costo: double.parse(_precioController.text), 
      ubicacion_cliente: '${_miPosicion!.latitude}, ${_miPosicion!.longitude}');
    
    int id = await registrarSolicitud(solicitud);
    
    if (id != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud registrada correctamente')),
      );
      solicitud.id = id;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropuestasSolicitudScreen(solicitud: solicitud), 
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrar los datos')),
      );
    }
  }
}