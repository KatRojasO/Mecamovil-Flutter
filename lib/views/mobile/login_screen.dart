// view/login_screen.dart
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            cajaColores(size),
            IconoPersona(),
            loginForm(context),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView loginForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 300), // Espacio desde la parte superior
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            height: 350, // Aumenta la altura del contenedor
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 25), // Espacio superior dentro del box
                Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(128, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50), // Más espacio entre el título y el primer botón
                // Botón para iniciar sesión con Google
                FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: const Size(250, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: () async {
                    try {
                      final user = await signInWithGoogle();
                      if (user != null) {
                        await checkAndAddUserToDatabase(user);
                        Navigator.pushReplacementNamed(context, 'home');
                      }
                    } on FirebaseAuthException catch (error) {
                      print(error.message);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(error.message ?? "Algo salió mal")),
                      );
                    } catch (error) {
                      print(error);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())),
                      );
                    }
                  },
                  icon: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.network(
                      'http://pngimg.com/uploads/google/google_PNG19635.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  label: const Text(
                    'Ingresar con Google',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Aumentar espacio vertical entre los botones
                // Botón para iniciar sesión con número de celular
                FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: const Size(250, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'phoneLogin');
                  },
                  icon: const Icon(Icons.phone, color: Colors.white),
                  label: const Text(
                    'Ingresar con Teléfono',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  SafeArea IconoPersona() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        width: double.infinity,
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 150,
        ),
      ),
    );
  }

  Container cajaColores(Size size) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(42, 25, 127, 1),
        Color.fromRGBO(105, 1, 78, 1)
      ])),
      width: double.infinity,
      height: size.height,
    );
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

    final url = Uri.parse('https://mecamovil.nexxosrl.site/api/check_user.php'); // Cambia por tu URL
    final response = await http.post(
      url,
      body: {
        'email': user.email!,
        'nombre': user.displayName?.split(' ')[0] ?? '',
        'apellido': user.displayName?.split(' ')[1] ?? '',
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
}
