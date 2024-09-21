
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/usuario_model.dart';

Future<Usuario> fetchUsuario(String email) async {
  final url = Uri.parse('https://mecamovil.nexxosrl.site/api/get_user.php'); //URL
  final response = await http.post(url, body: {'email': email});

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return Usuario.fromJson(data);
  } else {
    throw Exception('Error al obtener el usuario');
  }
}

Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    } catch (e) {
      print('Error en el inicio de sesión: $e');
      return null;
    }
  }

  Future<void> checkAndAddUserToDatabase(User? user) async {
    if (user == null) {
      print('No se pudo obtener la información del usuario.');
      return;
    }

    final url = Uri.parse('https://mecamovil.nexxosrl.site/api/check_user.php'); 
    final response = await http.post(
      url,
      body: {
        'email': user.email!,
        'nombre': user.displayName?.split(' ')[0] ?? '',
        //'apellido': user.displayName?.split(' ')[1] ?? '',
        'url_foto': user.photoURL?? '',
        'telefono': user.phoneNumber?? '',
        'fecha_registro':user.metadata.creationTime.toString(),
        'ultimo_inicio_sesion':user.metadata.creationTime.toString(),
        'tipo_usuario': 'cliente',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['exists']) {
        print('Usuario ya registrado.');
      } else {
        print('Usuario agregado a la base de datos.');
      }
    } else {
      print('Error al comunicarse con el servidor.');
    }
  }
