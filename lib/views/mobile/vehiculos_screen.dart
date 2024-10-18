import 'package:flutter/material.dart';
//import 'package:mecamovil/models/usuario_model.dart';
import 'package:mecamovil/models/vehiculo_model.dart';
//import 'package:mecamovil/controllers/usuario_controller.dart';
import 'package:mecamovil/controllers/vehiculo_controller.dart';
//import 'package:firebase_auth/firebase_auth.dart'; // Para obtener los datos de Firebase
import 'package:mecamovil/views/mobile/layouts/menu.dart';
import 'form_vehiculo.dart';
import 'package:session_storage/session_storage.dart';

class VehiculosScreen extends StatefulWidget {
  @override
  _VehiculosScreenState createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  List<Vehiculo> vehiculos=[];
  bool isLoading = true;
  String? userEmail;
  final session = SessionStorage();

  //Usuario? usuario;

  @override
  void initState() {
    super.initState();
    //Email del usuario actual desde Firebase
    /*User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fetchUsuario(user.email!).then((usuarioData) {
        setState(() {
          usuario = usuarioData;
          //userEmail = user.email;
        });
      });
    }*/
    
    userEmail = session['userEmail'];

    //Lista de Vehiculos del usuario
    obtenerVehiculos(userEmail!).then((listaVehiculos) {
      setState(() {
        vehiculos = listaVehiculos;
        isLoading = false;
      });
    });
  }
  
  void _mostrarVehiculosDetallados(Vehiculo vehiculo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Detalles del Vehículo', style: TextStyle(fontSize: 21),),
              ElevatedButton(
                onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormVehiculoScreen(vehiculo: vehiculo), 
                      ),
                    ).then((_) => setState(() {
                      obtenerVehiculos(userEmail!).then((listaVehiculos) {
                        setState(() {
                          vehiculos = listaVehiculos;
                        });
                      });
                      Navigator.of(context).pop();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(249, 215, 23, 1.0),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 22,
                  ),
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network((vehiculo.foto == null || vehiculo.foto=="") ? "https://img.freepik.com/premium-vector/error-404-found-glitch-effect_8024-4.jpg": vehiculo.foto!),
              const SizedBox(height: 30),
              Text('Marca: ${vehiculo.marca}'),
              Text('Modelo: ${vehiculo.modelo}'),
              Text('Tipo: ${vehiculo.tipo}'),
              Text('Cilindrada: ${vehiculo.cilindrada}'),
              Text('Placa: ${vehiculo.placa}'),
              Text('Color: ${vehiculo.color}'),
              Text('Combustible: ${vehiculo.combustible}'),
              Text('Tipo Motor: ${vehiculo.tipo_motor}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarVehiculo(Vehiculo vehiculo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar Vehiculo"),
          content: 
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: [
                  (vehiculo.clase_vehiculo == 'auto') ? TextSpan(text: '¿Esta seguro que desea eliminar el ${vehiculo.clase_vehiculo} con placa: '):
                  TextSpan(text: '¿Esta seguro que desea eliminar la ${vehiculo.clase_vehiculo} con placa: '),
                  TextSpan(text: '${vehiculo.placa}?', style: const TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Vehiculo vehi = vehiculo;
                vehi.estado_db = 0;
                editarVehiculo(vehi).then((value){
                  if (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vehiculo eliminado correctamente')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al eliminar el vehiculo')),
                    );
                  }
                  obtenerVehiculos(userEmail!).then((listaVehiculos) {
                    setState(() {
                      vehiculos = listaVehiculos;
                    });
                  });
                });
              }, 
              child: const Text("Acetar")
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: const Text("Cancelar")),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            SizedBox(width: 65),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mecamovil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.purple,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
        automaticallyImplyLeading: true,
      ),
      drawer: Menu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vehículos Registrados',
                    style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormVehiculoScreen(vehiculo: Vehiculo.vacio(usuario_id: int.parse(session['userId']!))), 
                      ),
                    ).then((_) => setState(() {
                      obtenerVehiculos(userEmail!).then((listaVehiculos) {
                        setState(() {
                          vehiculos = listaVehiculos;
                        });
                      });
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => obtenerVehiculos(userEmail!).then((listaVehiculos) {
                        setState(() {
                          vehiculos = listaVehiculos;
                        });
                      }),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7, // proporcion tarjetas
                        ),
                        itemCount: vehiculos.length,
                        itemBuilder: (context, index) {
                        final vehiculo = vehiculos[index];
                        return GestureDetector(
                          onTap: () => _mostrarVehiculosDetallados(vehiculo),
                          onLongPress: () => _eliminarVehiculo(vehiculo),
                          child: Card(
                            elevation: 4,
                            child: Column(
                              children: [
                                Image.network(
                                  (vehiculo.foto==null || vehiculo.foto=="") ? "https://img.freepik.com/premium-vector/error-404-found-glitch-effect_8024-4.jpg": vehiculo.foto!,
                                  width: double.infinity,
                                  height: 150, // altura de la imagen
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${vehiculo.clase_vehiculo}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('Marca: ${vehiculo.marca}', style: TextStyle(fontSize: 13)),
                                      Text('Placa: ${vehiculo.placa}', style: TextStyle(fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },)
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
