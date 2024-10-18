import 'package:mecamovil/models/vehiculo_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Vehiculo>> obtenerVehiculos(String emailUsuario) async {
  final url = Uri.parse('https://mecamovil.nexxosrl.site/api/obtener_vehiculos.php');
  List<Vehiculo> vehiculos = [];
  try {
    final response = await http.post(
      url,
      body: {
        'email': emailUsuario,
      },
    );

    if (response.statusCode == 200) {
      vehiculos = (jsonDecode(response.body) as List).map((data) => Vehiculo.fromMap(data)).toList();
    }
  } catch (e) {
    print(e.toString());
  }
  return vehiculos;
}

Future<bool> registrarVehiculo(Vehiculo vehiculo) async {
  final url = Uri.parse('https://mecamovil.nexxosrl.site/api/registrar_vehiculo.php');

  final response = await http.post(
    url,
    body: {
      'usuario_id': vehiculo.usuario_id.toString(), 
      'clase_vehiculo': vehiculo.clase_vehiculo,
      'marca': vehiculo.marca,
      'modelo': vehiculo.modelo,
      'placa': vehiculo.placa,
      'tipo': vehiculo.tipo,
      'cilindrada': vehiculo.cilindrada,
      'foto': vehiculo.foto ?? '',
      'color': vehiculo.color ?? '',
      'combustible': vehiculo.combustible ?? '',
      'tipo_motor': vehiculo.tipo_motor ?? '',
      'estado_db': vehiculo.estado_db.toString(),
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success']) {
      print('Vehiculo registrado correctamente');
      return true;  
    } else {
      print('Error al registrar el vehiculo: ${data['message']}');
      return false;  
    }
  } else {
    print('Error al comunicarse con el servidor.');
    return false;
  }
}

Future<bool> editarVehiculo(Vehiculo vehiculo) async {
  final url = Uri.parse('https://mecamovil.nexxosrl.site/api/editar_vehiculo.php');

  final response = await http.post(
    url,
    body: {
      'id': vehiculo.id.toString(),
      'usuario_id': vehiculo.usuario_id.toString(), 
      'clase_vehiculo': vehiculo.clase_vehiculo,
      'marca': vehiculo.marca,
      'modelo': vehiculo.modelo,
      'placa': vehiculo.placa,
      'tipo': vehiculo.tipo,
      'cilindrada': vehiculo.cilindrada,
      'foto': vehiculo.foto ?? '',
      'color': vehiculo.color ?? '',
      'combustible': vehiculo.combustible ?? '',
      'tipo_motor': vehiculo.tipo_motor ?? '',
      'estado_db': vehiculo.estado_db.toString(),
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success']) {
      print('Vehiculo editado correctamente');
      return true;  
    } else {
      print('Error al editar el vehiculo: ${data['message']}');
      return false;  
    }
  } else {
    print('Error al comunicarse con el servidor.');
    return false;
  }
}