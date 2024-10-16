class Historial_Servicio {
  int _id;
  int _solicitud_id;
  DateTime _fecha_servicio;
  double _costo;
  String _comentarios;
  int _calificacion;

  // Constructor
  Historial_Servicio({
    required int id,
    required int solicitud_id,
    required DateTime fecha_servicio,
    required double costo,
    required String comentarios,
    required int calificacion,

  })  : _id = id,
        _solicitud_id = solicitud_id,
        _fecha_servicio = fecha_servicio,
        _costo = costo,
        _comentarios = comentarios,
        _calificacion = calificacion;

  // Constructor 2
  Historial_Servicio.vacio({required int solicitud_id})  : 
        _id = 0,
        _solicitud_id = solicitud_id,
        _fecha_servicio = DateTime.now(),
        _costo = 0.0,
        _comentarios = "",
        _calificacion = 0;

  // Método para convertir de un Map a un objeto Vehiculo
  factory Historial_Servicio.fromMap(Map<String, dynamic> map) {
    return Historial_Servicio(
      id: map['id'],
      solicitud_id: map['solicitud_id'],
      fecha_servicio: map['fecha_servicio'],
      costo: map['marca'],
      comentarios: map['modelo'],
      calificacion: map['placa']
    );
  }

  // Método para convertir un objeto Vehiculo a un Map (para guardar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'solicitud_id': _solicitud_id,
      'fecha_servicio': _fecha_servicio,
      'costo': _costo,
      'comentarios': _comentarios,
      'calificacion': _calificacion
    };
  }

  // Getters y Setters
  int get id => _id;
  set id(int value) {
    _id = value;
  }

  int get solicitud_id => _solicitud_id;
  set solicitud_id(int value) {
    _solicitud_id = value;
  }

  DateTime get fecha_servicio => _fecha_servicio;
  set fecha_servicio(DateTime value) {
    _fecha_servicio = value;
  }

  double get costo => _costo;
  set costo(double value) {
    _costo = value;
  }

  String get comentarios => _comentarios;
  set comentarios(String value) {
    _comentarios = value;
  }

  int get calificacion => _calificacion;
  set calificacion(int value) {
    _calificacion = value;
  }
}
