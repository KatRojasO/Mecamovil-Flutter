class Notificacion{
  int _id;
  int _usuario_id;
  String _mensaje;
  DateTime _fecha_envio;
  int _leido;

  //Constructor
  Notificacion({
    required int id,
    required int usuario_id,
    required String mensaje,
    required DateTime fecha_envio,
    required int leido
  }) : _id = id,
       _usuario_id = usuario_id,
       _mensaje = mensaje,
       _fecha_envio = fecha_envio,
       _leido = leido;
  
  //Constructor 2
  Notificacion.vacio({required int usuario_id}) :
    _id = 0,
    _usuario_id = usuario_id,
    _mensaje = "pendiente",
    _fecha_envio = DateTime.now(),
    _leido = 0;

  factory Notificacion.fromMap(Map<String, dynamic> map){
    return Notificacion(
      id: map['id'], 
      usuario_id: map['usuario_id'],
      mensaje: map['mensaje'],
      fecha_envio: map['fecha_envio'], 
      leido: map['leido']
    );
  }

  int get id => _id;
  set id(int value) {
    _id = value;
  }

  int get usuario_id => _usuario_id;
  set usuario_id(int value) {
    _usuario_id = value;
  }

  String get mensaje => _mensaje;
  set mensaje(String value) {
    _mensaje = value;
  }

  DateTime get fecha_envio => _fecha_envio;
  set fecha_envio(DateTime value) {
    _fecha_envio = value;
  }

  int get leido => _leido;
  set leido(int value) {
    _leido = value;
  }
}