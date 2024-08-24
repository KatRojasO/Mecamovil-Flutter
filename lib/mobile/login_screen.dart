import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mecamovil/widgets/input_decoration.dart';

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
                const SizedBox(height: 250),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
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
                   const SizedBox(height: 10),
                  Text('Login',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 30),  
                Container(
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecorations.inputDecoration(
                          hintext: 'ejemplo@gmail.com', 
                          labeltext: 'Correo Electrónico', 
                          icon: const Icon(Icons.person_sharp)),
                        validator: (value) {
                          String pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                          RegExp regExp =new RegExp(pattern);
                          return regExp.hasMatch(value ?? '')
                            ? null
                            : 'Correo Electrónico Inválido';

                        },
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        autocorrect: false,
                        obscureText: true,
                        decoration: InputDecorations.inputDecoration(
                          hintext: '*******', 
                          labeltext: 'Contraseña', 
                          icon: const Icon(Icons.lock_outlined)),
                          validator: (value) {
                            return( value != null && value.length>=6)
                              ?null
                              : '';
                          },
                      ),
                      const SizedBox(height: 30),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, 'home');
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        color: Colors.purple,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Text('Ingresar', style: TextStyle(color: Colors.white, fontSize: 17)),
                        ),
                      )
                    ],
                  )),
                )
                ],
              )),
          const SizedBox(height: 50),
          const Text(
            'Crear una nueva cuenta',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
              ],
            ),
    );
  }

  SafeArea IconoPersona() {
    return SafeArea(child: 
            Container(
              margin: const EdgeInsets.only(top: 30),
              width: double.infinity,
              child: const Icon(
              Icons.person_pin,
              color: Colors.white,
              size: 100,
            ),
          ),);
  }

  Container cajaColores(Size size) {
    return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(42, 25, 127, 1),
                Color.fromRGBO(105, 1, 78, 1)
              ]
                
              )
            ) ,
            width: double.infinity,
            height: size.height * 0.4 ,
            
          );
  }
}