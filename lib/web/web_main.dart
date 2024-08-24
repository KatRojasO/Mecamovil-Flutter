import 'package:flutter/material.dart';

void main() {
  runApp(WebApp());
}

class WebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,  // Esto elimina la cinta "Debug"
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A197F), Color(0xFF69014E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45.0),
              ),
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Inicio de Sesión',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2A197F),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 300),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Correo Electrónico',
                                labelStyle: TextStyle(color: Color(0xFF2A197F)),
                                prefixIcon: Icon(Icons.email, color: Color(0xFF2A197F)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su correo electrónico';
                                }
                                final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                if (!emailRegExp.hasMatch(value)) {
                                  return 'Ingrese un correo electrónico válido';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                labelStyle: TextStyle(color: Color(0xFF2A197F)),
                                prefixIcon: Icon(Icons.lock, color: Color(0xFF2A197F)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility_off : Icons.visibility,
                                    color: Color(0xFF2A197F),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su contraseña';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.0),
                      MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            // Aplicar efecto de brillo
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            // Eliminar efecto de brillo
                          });
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() == true) {
                              // Lógica de autenticación
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF69014E),
                            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          // Lógica para recuperar contraseña
                        },
                        child: Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(color: Color(0xFF69014E)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
