import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/input_decoration.dart'; 
class CodigoScreen extends StatefulWidget {
  final String email;

  CodigoScreen({required this.email});

  @override
  _CodigoScreenState createState() => _CodigoScreenState();
}

class _CodigoScreenState extends State<CodigoScreen> {
  final codigoController = TextEditingController();
  bool _isLoading = false;

  // Función para verificar el código en la base de datos
  Future<void> verificarCodigo() async {
    setState(() {
      _isLoading = true;
    });

    final codigo = codigoController.text.trim();

    final url = 'https://mecamovil.nexxosrl.site/api/verificar_codigo.php';

    // Solicitud POST
    final response = await http.post(
      Uri.parse(url),
      body: {
        'email': widget.email,
        'codigo': codigo
      },
    );

    final data = json.decode(response.body);

    setState(() {
      _isLoading = false;
    });

    if (data['valido'] == true) {
      Navigator.pushNamed(context, 'new_password', arguments: widget.email);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Código incorrecto'),
            content: Text('El código ingresado no es válido. Inténtalo de nuevo.'),
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
                  'Ingrese el código enviado a su correo',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: codigoController,
                  decoration: InputDecorations.inputDecoration(
                    hintext: 'Código de verificación',
                    labeltext: 'Código',
                    icon: Icon(Icons.vpn_key, color: Colors.deepPurple),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : verificarCodigo,
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
                            'Verificar',
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
