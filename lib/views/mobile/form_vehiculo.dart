import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../models/vehiculo_model.dart';
import '../../controllers/vehiculo_controller.dart';
import 'package:image_picker/image_picker.dart';

class FormVehiculoScreen extends StatefulWidget {
  final Vehiculo vehiculo;

  FormVehiculoScreen({required this.vehiculo});

  @override
  _FormVehiculoScreenState createState() => _FormVehiculoScreenState();
}

class _FormVehiculoScreenState extends State<FormVehiculoScreen> {
  late String _claseVehiculo;
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _placaController;
  late TextEditingController _tipoController;
  late TextEditingController _cilindradaController;
  late TextEditingController _colorController;
  late TextEditingController _combustibleController;
  late TextEditingController _tipoMotorController;
  final _formKey = GlobalKey<FormState>();
  File? _imagenSeleccionada;
  bool _imagenCambiada = false;

  @override
  void initState() {
    super.initState();
    _claseVehiculo = widget.vehiculo.clase_vehiculo;
    _marcaController = TextEditingController(text: widget.vehiculo.marca);
    _modeloController = TextEditingController(text: widget.vehiculo.modelo);
    _placaController = TextEditingController(text: widget.vehiculo.placa);
    _tipoController = TextEditingController(text: widget.vehiculo.tipo);
    _cilindradaController = TextEditingController(text: widget.vehiculo.cilindrada);
    _colorController = TextEditingController(text: widget.vehiculo.color);
    _combustibleController = TextEditingController(text: widget.vehiculo.combustible);
    _tipoMotorController = TextEditingController(text: widget.vehiculo.tipo_motor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehiculo'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _seleccionarNuevaImagen,
                child:  _imagenSeleccionada != null
                    ? Image(image: FileImage(_imagenSeleccionada!))
                    : (widget.vehiculo.foto != null && widget.vehiculo.foto != "")
                        ? Image(image: NetworkImage(widget.vehiculo.foto!))
                        : const Image(image: AssetImage("assets/not_found.png")),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo es obligatorio';
                  }
                  return null;
                },
                value: _claseVehiculo,
                decoration: const InputDecoration(labelText: 'Clase*'),
                items: ['auto', 'moto'].map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(), 
                onChanged: (value) {
                  setState(() {
                    _claseVehiculo = value!;
                  });
                }),
              const SizedBox(height: 20),
              TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo es obligatorio';
                  }
                  return null;
                },
                controller: _placaController,
                decoration: const InputDecoration(labelText: 'Placa*'),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo es obligatorio';
                  }
                  return null;
                },
                controller: _tipoController,
                decoration: const InputDecoration(labelText: 'Tipo*'),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo es obligatorio';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                controller: _cilindradaController,
                decoration: const InputDecoration(labelText: 'Cilindrada*'),
              ),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Color'),
              ),
              TextFormField(
                controller: _combustibleController,
                decoration: const InputDecoration(labelText: 'Combustible'),
              ),
              TextFormField(
                controller: _tipoMotorController,
                decoration: const InputDecoration(labelText: 'Tipo de motor'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Procesando la información...')),
                    );
                  }

                  _guardarCambios();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Fondo
                  foregroundColor: Colors.white, // Texto
                ),
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }

 void _guardarCambios() async {
    String? nuevaUrlFoto = widget.vehiculo.foto;

    // Si la imagen ha sido cambiada, elimina la imagen anterior y sube la nueva imagen
    if (_imagenCambiada && _imagenSeleccionada != null) {

      await _eliminarImagen(widget.vehiculo.foto ?? '');
      // Subir la nueva imagen
      nuevaUrlFoto = await _subirImagen(_imagenSeleccionada!);
    }

    Vehiculo vehiculo = Vehiculo(
      id: widget.vehiculo.id, 
      usuario_id: widget.vehiculo.usuario_id, 
      clase_vehiculo: _claseVehiculo, 
      marca: _marcaController.text, 
      modelo: _modeloController.text, 
      placa: _placaController.text, 
      tipo: _tipoController.text, 
      cilindrada: _cilindradaController.text,
      foto: nuevaUrlFoto,
      color: _colorController.text,
      combustible: _combustibleController.text,
      tipo_motor: _tipoMotorController.text,
      estado_db: widget.vehiculo.estado_db
    );
    bool exito;
    if (vehiculo.id == 0) {
      exito = await registrarVehiculo(vehiculo);
    } else {
      exito = await editarVehiculo(vehiculo);
    }

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos actualizados correctamente')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar los datos')),
      );
    }
  }

  Future<String> _subirImagen(File imagen) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('fotos_perfil/${DateTime.now().millisecondsSinceEpoch}.jpg');

      await storageRef.putFile(imagen);
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      print('Error al subir la imagen: $e');
      return '';
    }
  }

  Future<void> _eliminarImagen(String urlImagen) async {
    if (urlImagen.isNotEmpty) {
      try {
        final Reference storageRef =
            FirebaseStorage.instance.refFromURL(urlImagen);
        await storageRef.delete();
        print('Imagen eliminada con éxito');
      } catch (e) {
        print('Error al eliminar imagen: $e');
      }
    }
  }

  Future<void> _seleccionarNuevaImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagenSeleccionada =
        await picker.pickImage(source: ImageSource.gallery);

    if (imagenSeleccionada != null) {
      setState(() {
        _imagenSeleccionada = File(imagenSeleccionada.path);
        _imagenCambiada = true; 
      });
    }
  }
}