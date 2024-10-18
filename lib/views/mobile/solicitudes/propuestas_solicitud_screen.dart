import 'package:flutter/material.dart';
import 'package:mecamovil/models/solicitud_asistencia_model.dart';

class PropuestasSolicitudScreen extends StatefulWidget {
  final Solicitud_Asistencia solicitud;
  const PropuestasSolicitudScreen({required this.solicitud});

  @override
  State<PropuestasSolicitudScreen> createState() => _PropuestasSolicitudScreenState();
}

class _PropuestasSolicitudScreenState extends State<PropuestasSolicitudScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscando mecánico'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('id: ${widget.solicitud.id}'),
      ),
    );
  }
}