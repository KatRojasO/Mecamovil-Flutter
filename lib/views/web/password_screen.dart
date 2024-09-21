import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/input_decoration.dart'; // Para la clase InputDecorations

class PasswordScreen extends StatefulWidget {
  final String email;

  PasswordScreen({required this.email});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final passwordController = TextEditingController();
  bool isLoading = false;

  // Función para verificar la contraseña
  Future<void> verificarContrasena() async {
    final password = passwordController.text.trim();

    // Validar que la contraseña no esté vacía
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese su contraseña.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // URL de tu servidor (modifica con tu servidor real)
      final url = 'https://mecamovil.nexxosrl.site/api/verificar_contrasenia.php';

      // Hacer la solicitud POST al servidor
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': widget.email,
          'contrasenia': password,
        },
      );

      final data = json.decode(response.body);

      // Si la contraseña es correcta, redirigir al home
      if (data['success'] == true) {
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        // Si la contraseña es incorrecta, mostrar un mensaje
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña incorrecta. Inténtelo nuevamente.')),
        );
      }
    } catch (error) {
      // Mostrar error en caso de que falle la solicitud
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error. Inténtelo de nuevo.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para generar el código y redirigir a la pantalla de código
  Future<void> generarCodigo() async {
    setState(() {
      isLoading = true;
    });

    try {
      // URL de tu servidor para generar el código
      final urlGenerarCodigo =
          'https://mecamovil.nexxosrl.site/api/generar_codigo.php';

      // Hacer la solicitud POST para generar el código
      final response = await http.post(
        Uri.parse(urlGenerarCodigo),
        body: {'email': widget.email},
      );

      final data = json.decode(response.body);

      if (data['enviado'] == true) {
        // Redirigir a la pantalla de código si el código se envió correctamente
        Navigator.pushNamed(context, 'codigo', arguments: widget.email);
      } else {
        // Si no se pudo enviar el código, mostrar un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo enviar el código. Inténtelo de nuevo.')),
        );
      }
    } catch (error) {
      // Mostrar error en caso de que falle la solicitud
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error. Inténtelo de nuevo.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(45),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 8),
                  blurRadius: 16,
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width * 0.50,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ingrese su contraseña',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecorations.inputDecoration(
                    hintext: 'Ingrese su contraseña',
                    labeltext: 'Contraseña',
                    icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : verificarContrasena,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color(0xFF69014E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Ingresar',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  ),
                ),
                SizedBox(height: 24),
                TextButton(
                  onPressed: isLoading ? null : generarCodigo,
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
