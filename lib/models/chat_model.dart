class Chat {
  int _id;
  int _solicitud_id;
  int _emisor_id;
  int _receptor_id;
  String _mensaje;
  DateTime _fecha_envio;

  // Constructor
  Chat({
    required int id,
    required int solicitud_id,
    required int emisor_id,
    required int receptor_id,
    required String mensaje,
    required DateTime fecha_envio,

  })  : _id = id,
        _solicitud_id = solicitud_id,
        _emisor_id = emisor_id,
        _receptor_id = receptor_id,
        _mensaje = mensaje,
        _fecha_envio = fecha_envio;

  // Constructor 2
  Chat.vacio({required int solicitud_id})  : 
        _id = 0,
        _solicitud_id = solicitud_id,
        _emisor_id = 0,
        _receptor_id = 0,
        _mensaje = "",
        _fecha_envio = DateTime.now();

  // Método para convertir de un Map a un objeto Vehiculo
  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      solicitud_id: map['solicitud_id'],
      emisor_id: map['emisor_id'],
      receptor_id: map['receptor_id'],
      mensaje: map['mensaje'],
      fecha_envio: map['fecha_envio'],
    );
  }

  // Método para convertir un objeto Vehiculo a un Map (para guardar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'solicitud_id': _solicitud_id,
      'emisor_id': _emisor_id,
      'receptor_id': _receptor_id,
      'mensaje': _mensaje,
      'fecha_envio': _fecha_envio
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

  int get emisor_id => _emisor_id;
  set emisor_id(int value) {
    _emisor_id = value;
  }

  int get receptor_id => _receptor_id;
  set receptor_id(int value) {
    _receptor_id = value;
  }

  String get mensaje => _mensaje;
  set mensaje(String value) {
    _mensaje = value;
  }

  DateTime get fecha_envio => _fecha_envio;
  set fecha_envio(DateTime value) {
    _fecha_envio = value;
  }
}
