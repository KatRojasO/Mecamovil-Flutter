import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/input_decoration.dart'; 

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final emailController = TextEditingController();
  bool isLoading = false; 

  Future<void> verificarEmail(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese su correo electrónico.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = 'https://mecamovil.nexxosrl.site/api/verificar_email.php';

      // Hacer la solicitud POST 
      final response = await http.post(
        Uri.parse(url),
        body: {'email': email},
      );

      final data = json.decode(response.body); // Decodificar la respuesta JSON

      if (data['existe'] == true &&
          data['contrasenia'] == null &&
          data['tipo_usuario'] == 'administrador') {

        final urlGenerarCodigo =
            'https://mecamovil.nexxosrl.site/api/generar_codigo.php';

        final responseCodigo = await http.post(
          Uri.parse(urlGenerarCodigo),
          body: {'email': email},
        );

        final codigoData = json.decode(responseCodigo.body);

        if (codigoData['enviado'] == true) {
          Navigator.pushNamed(context, 'codigo', arguments: email);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('No se pudo enviar el código. Inténtelo nuevamente.')),
          );
        }
      }
      else if (data['existe'] == true &&
          data['contrasenia'] != null &&
          data['tipo_usuario'] == 'administrador') {
        Navigator.pushNamed(context, 'password', arguments: email);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('El correo no es válido o no es de un administrador.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Ocurrió un error. Por favor, inténtelo de nuevo.')),
      );
    } finally {
      // Ocultar el indicador de carga
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
                  'Ingrese su correo electrónico',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  decoration: InputDecorations.inputDecoration(
                    hintext: 'Ingrese su correo electrónico',
                    labeltext: 'Correo Electrónico',
                    icon: Icon(Icons.email_outlined, color: Colors.deepPurple),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => verificarEmail(
                            context), // Deshabilitar botón mientras se carga
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color(0xFF69014E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white) // Mostrar indicador de carga
                        : Text(
                            'Siguiente',
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
