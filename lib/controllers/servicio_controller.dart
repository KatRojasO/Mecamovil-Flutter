import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mecamovil/models/servicio_model.dart';

Future<List<Servicio>> obtenerServicios() async {
  final url = Uri.parse('https://mecamovil.nexxosrl.site/api/obtener_servicios.php');
  List<Servicio> servicios = [];
  try {
    final response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      servicios = (jsonDecode(response.body) as List).map((data) => Servicio.fromMap(data)).toList();
    }
  } catch (e) {
    print(e.toString());
  }
  return servicios;
}