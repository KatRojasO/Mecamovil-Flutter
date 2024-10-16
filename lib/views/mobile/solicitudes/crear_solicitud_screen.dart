import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../layouts/menu.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:geolocator/geolocator.dart';

class CrearSolicitudScreen extends StatefulWidget {
  const CrearSolicitudScreen({super.key});

  @override
  State<CrearSolicitudScreen> createState() => _CrearSolicitudScreenState();
}

class _CrearSolicitudScreenState extends State<CrearSolicitudScreen> {
  final MAPBOX_ACCESS_TOKEN = "pk.eyJ1Ijoia2V2aW5jaG85NCIsImEiOiJjbTI5eWtzamswMmNvMnBxMnc2MWo3bmlxIn0.q75ivDjG_oBFsTxhybuogg";
  LatLng _miPosicion =LatLng(0, 0);
  
  /*Future<Position> determinarPosicion() async {
    LocationPermission permisos;
    permisos = await Geolocator.checkPermission();
    if (permisos == LocationPermission.denied) {
      permisos = await Geolocator.requestPermission();
      if (permisos == LocationPermission.denied) {
        return Future.error('La aplicacion necesita permisos para acceder a la ubicación.');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void obtenerUbicacion() async {
    Position posicion = await determinarPosicion();
    _miPosicion = LatLng(posicion.latitude, posicion.longitude);
  }*/


  @override
  void initState() {
    super.initState();
    //obtenerUbicacion();
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
      body: 
            FlutterMap(
              options: MapOptions(
                initialCenter: _miPosicion,
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
                      point: _miPosicion, 
                      child: const Icon(
                        Icons.pin_drop_sharp,
                        color: Colors.purple,
                        size: 40,
                      )
                    ),
                  ]),
              ],
            ),
        
        
      );
  }
}