import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../models/usuario_model.dart';
import '../../controllers/usuario_controller.dart';
import 'package:image_picker/image_picker.dart';

class EditarUsuarioScreen extends StatefulWidget {
  final Usuario usuario;

  EditarUsuarioScreen({required this.usuario});

  @override
  _EditarUsuarioScreenState createState() => _EditarUsuarioScreenState();
}

class _EditarUsuarioScreenState extends State<EditarUsuarioScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;
  File? _imagenSeleccionada;
  bool _imagenCambiada = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.usuario.nombre);
    _apellidoController = TextEditingController(text: widget.usuario.apellido);
    _emailController = TextEditingController(text: widget.usuario.email);
    _telefonoController =
        TextEditingController(text: widget.usuario.telefono ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _seleccionarNuevaImagen,
              child: CircleAvatar(
                radius: 100,
                backgroundImage: _imagenSeleccionada != null
                    ? FileImage(_imagenSeleccionada!)
                    : widget.usuario.url_foto != null
                        ? NetworkImage(widget.usuario.url_foto!)
                        : AssetImage('assets/default_profile.png')
                            as ImageProvider,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre(s)'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _apellidoController,
              decoration: InputDecoration(labelText: 'Apellido(s)'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarCambios,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Fondo
                foregroundColor: Colors.white, // Texto
              ),
              child: Text('Guardar cambios'),
            ),
          ],
        ),
      ),
      )
    );
  }

  void _guardarCambios() async {
    String? nuevaUrlFoto = widget.usuario.url_foto;

    // Si la imagen ha sido cambiada, elimina la imagen anterior y sube la nueva imagen
    if (_imagenCambiada && _imagenSeleccionada != null) {

      await _eliminarImagen(widget.usuario.url_foto ?? '');
      // Subir la nueva imagen
      nuevaUrlFoto = await _subirImagen(_imagenSeleccionada!);
    }

    Usuario usuarioActualizado = Usuario(
      id: widget.usuario.id,
      nombre: _nombreController.text,
      apellido: _apellidoController.text,
      email: _emailController.text,
      telefono: _telefonoController.text,
      url_foto: nuevaUrlFoto,
      fecha_registro: widget.usuario.fecha_registro,
      ultimo_inicio_sesion: widget.usuario.ultimo_inicio_sesion,
      tipoUsuario: widget.usuario.tipoUsuario,
      estado: widget.usuario.estado,
    );

    bool exito = await actualizarUsuario(usuarioActualizado);

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos actualizados correctamente')),
      );
      Navigator.pushNamed(context, 'home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar los datos')),
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
