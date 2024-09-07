import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/usuario_model.dart';

Future<Usuario> fetchUsuario(String email) async {
  final url = Uri.parse('https://mecamovil.nexxosrl.site/api/get_user.php'); // Cambia por tu URL
  final response = await http.post(url, body: {'email': email});

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return Usuario.fromJson(data);
  } else {
    throw Exception('Error al obtener el usuario');
  }
}
