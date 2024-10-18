class Servicio {
  int _id;
  String _servicio;
  String _descripcion;

  // Constructor
  Servicio({
    required int id,
    required String servicio,
    required String descripcion,

  })  : _id = id,
        _servicio = servicio,
        _descripcion = descripcion;

  // Método para convertir de un Map a un objeto Vehiculo
  factory Servicio.fromMap(Map<String, dynamic> map) {
    return Servicio(
      id: int.parse(map['id']),
      servicio: map['servicio'],
      descripcion: map['descripcion']
    );
  }

  // Método para convertir un objeto Vehiculo a un Map (para guardar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'servicio': _servicio,
      'descripcion': _descripcion
    };
  }

  // Getters y Setters
  int get id => _id;
  set id(int value) {
    _id = value;
  }

  String get servicio => _servicio;
  set servicio(String value) {
    _servicio = value;
  }

  String get descripcion => _descripcion;
  set descripcion(String value) {
    _descripcion = value;
  }

}
