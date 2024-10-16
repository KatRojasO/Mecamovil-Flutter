class Solicitud_Asistencia{
  int _id;
  int _cliente_id;
  int? _mecanico_id;
  int _vehiculo_id;
  String _descripcion_problema;
  String _estado;
  DateTime _fecha_solicitud;
  double _costo_estimado;
  String _ubicacion_cliente;

  //Constructor
  Solicitud_Asistencia({
    required int id,
    required int cliente_id,
    int? mecanico_id,
    required int vehiculo_id,
    required descripcion_problema,
    required String estado,
    required DateTime fecha_solicitud,
    required double costo_estimado,
    required String ubicacion_cliente
  }) : _id = id,
       _cliente_id = cliente_id,
       _mecanico_id = mecanico_id!,
       _vehiculo_id = vehiculo_id,
       _descripcion_problema = descripcion_problema,
       _estado = estado,
       _fecha_solicitud = fecha_solicitud,
       _costo_estimado = costo_estimado,
       _ubicacion_cliente = ubicacion_cliente;
  
  //Constructor 2
  Solicitud_Asistencia.vacio({required int cliente_id}) :
    _id = 0,
    _cliente_id = cliente_id,
    _mecanico_id = 0,
    _vehiculo_id = 0,
    _descripcion_problema = "",
    _estado = "pendiente",
    _fecha_solicitud = DateTime.now(),
    _costo_estimado = 0.0,
    _ubicacion_cliente = "";

  factory Solicitud_Asistencia.fromMap(Map<String, dynamic> map){
    return Solicitud_Asistencia(
      id: map['id'], 
      cliente_id: map['cliente_id'], 
      mecanico_id: map['mecanico_id'], 
      vehiculo_id: map['vehiculo_id'], 
      descripcion_problema: map['descripcion_problema'], 
      estado: map['estado'], 
      fecha_solicitud: map['fecha_solicitud'], 
      costo_estimado: map['costo_estimado'], 
      ubicacion_cliente: map['ubicacion_cliente']
    );
  }

  int get id => _id;
  set id(int value) {
    _id = value;
  }

  int get cliente_id => _cliente_id;
  set cliente_id(int value) {
    _cliente_id = value;
  }

  int get mecanico_id => _mecanico_id!;
  set mecanico_id(int value) {
    _mecanico_id = value;
  }

  int get vehiculo_id => _vehiculo_id;
  set vehiculo_id(int value) {
    _vehiculo_id = value;
  }

  String get descripcion_problema => _descripcion_problema;
  set descripcion_problema(String value) {
    _descripcion_problema = value;
  }

  String get estado => _estado;
  set estado(String value) {
    _estado = value;
  }

  DateTime get fecha_solicitud => _fecha_solicitud;
  set fecha_solicitud(DateTime value) {
    _fecha_solicitud = value;
  }

  double get costo_estimado => _costo_estimado;
  set costo_estimado(double value) {
    _costo_estimado = value;
  }

  String get ubicacion_cliente => _ubicacion_cliente;
  set ubicacion_cliente(String value) {
    _ubicacion_cliente = value;
  }
}