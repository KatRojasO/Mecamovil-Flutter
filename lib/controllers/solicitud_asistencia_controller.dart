import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mecamovil/models/solicitud_asistencia_model.dart';

Future<List<Solicitud_Asistencia>> obtenerSolicitudesCliente(int id, String estado) async {
  final url = Uri.parse('https://mecamovil.nexxosrl.site/api/obtener_solicitudes_cliente.php');
  List<Solicitud_Asistencia> solicitudes = [];
  try {
    final response = await http.post(
      url,
      body: {
        'cliente_id': id,
        'estado': estado,
      },
    );

    if (response.statusCode == 200) {
      solicitudes = (jsonDecode(response.body) as List).map((data) => Solicitud_Asistencia.fromMap(data)).toList();
    }
  } catch (e) {
    print(e.toString());
  }
  return solicitudes;
}

Future<int> registrarSolicitud(Solicitud_Asistencia solicitud) async {
  final url = Uri.parse('https://mecamovil.nexxosrl.site/api/registrar_solicitud_servicio.php');

  final response = await http.post(
    url,
    body: {
      'cliente_id': solicitud.cliente_id.toString(),
      'mecanico_id': "",
      'vehiculo_id': solicitud.vehiculo_id.toString(),
      'descripcion_problema': solicitud.descripcion_problema,
      'estado': solicitud.estado,
      'fecha_solicitud': '${solicitud.fecha_solicitud.year}-${solicitud.fecha_solicitud.month}-${solicitud.fecha_solicitud.day} ${solicitud.fecha_solicitud.hour}:${solicitud.fecha_solicitud.minute}:${solicitud.fecha_solicitud.second}',
      'costo': solicitud.costo.toString(),
      'ubicacion_cliente': solicitud.ubicacion_cliente,
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success']) {
      print('Solicitud registrado correctamente, id ${data['id']}');
      return data['id'];  
    } else {
      print('Error al registrar el solicitud: ${data['message']}');
      return 0;  
    }
  } else {
    print('Error al comunicarse con el servidor.');
    return 0;
  }
}

Future<bool> editarSolicitud(Solicitud_Asistencia solicitud) async {
  final url = Uri.parse('https://mecamovil.nexxosrl.site/api/editar_solicitud_servicio.php');

  final response = await http.post(
    url,
    body: {
      'id': solicitud.id.toString(),
      'cliente_id': solicitud.cliente_id.toString(), 
      'mecanico_id': solicitud.mecanico_id.toString(),
      'vehiculo_id': solicitud.vehiculo_id.toString(),
      'descripcion_problema': solicitud.descripcion_problema,
      'estado': solicitud.estado,
      'fecha_solicitud': solicitud.fecha_solicitud,
      'costo': solicitud.costo,
      'ubicacion_cliente': solicitud.ubicacion_cliente,
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success']) {
      print('Solicitud editada correctamente');
      return true;  
    } else {
      print('Error al editar el solicitud: ${data['message']}');
      return false;  
    }
  } else {
    print('Error al comunicarse con el servidor.');
    return false;
  }
}