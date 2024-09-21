import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/input_decoration.dart'; 

class NewPasswordScreen extends StatefulWidget {
  final String email;

  NewPasswordScreen({required this.email});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  // Función para restablecer la contraseña
  Future<void> restablecerContrasena() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      _mostrarAlerta('Por favor, complete ambos campos');
      return;
    }

    if (password != confirmPassword) {
      _mostrarAlerta('Las contraseñas no coinciden');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url =
        'https://mecamovil.nexxosrl.site/api/actualizar_contrasenia.php';


    try {
    // Hacer la solicitud POST
    final response = await http.post(
      Uri.parse(url),
      body: {
        'email': widget.email,
        'contrasenia': password,
      },
    );

    final data = json.decode(response.body);

    if (data['success'] == true) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      _mostrarAlerta(data['message'] ?? 'Hubo un problema al actualizar la contraseña');
    }
  } catch (e) {
    _mostrarAlerta('Ocurrió un error: $e');
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
  }

  // Función para mostrar alertas
  void _mostrarAlerta(String mensaje) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
                  'Restablecer contraseña',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                // Campo para la nueva contraseña
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecorations.inputDecoration(
                    hintext: 'Ingrese su nueva contraseña',
                    labeltext: 'Nueva contraseña',
                    icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                  ),
                ),
                SizedBox(height: 24),
                // Campo para confirmar la nueva contraseña
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecorations.inputDecoration(
                    hintext: 'Confirme su nueva contraseña',
                    labeltext: 'Confirmar contraseña',
                    icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                  ),
                ),
                SizedBox(height: 24),
                // Botón para restablecer la contraseña
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : restablecerContrasena,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color(0xFF69014E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Restablecer',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
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
