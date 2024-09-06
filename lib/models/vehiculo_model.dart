class Vehiculo {
  int _id;
  int _usuario_id; // dueño del vehículo (usuario)
  String _tipo_vehiculo; // Puede ser 'auto' o 'moto'
  String _marca;
  String _modelo;
  int _anio; 

  // Constructor
  Vehiculo({
    required int id,
    required int usuario_id,
    required String tipo_vehiculo,
    required String marca,
    required String modelo,
    required int anio,
  })  : _id = id,
        _usuario_id = usuario_id,
        _tipo_vehiculo = tipo_vehiculo,
        _marca = marca,
        _modelo = modelo,
        _anio = anio;

  // Método para convertir de un Map a un objeto Vehiculo
  factory Vehiculo.fromMap(Map<String, dynamic> map) {
    return Vehiculo(
      id: map['id'],
      usuario_id: map['usuario_id'],
      tipo_vehiculo: map['tipo_vehiculo'],
      marca: map['marca'],
      modelo: map['modelo'],
      anio: map['anio'],
    );
  }

  // Método para convertir un objeto Vehiculo a un Map (para guardar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'usuario_id': _usuario_id,
      'tipo_vehiculo': _tipo_vehiculo,
      'marca': _marca,
      'modelo': _modelo,
      'anio': _anio,
    };
  }

  // Getters y Setters
  int get id => _id;
  set id(int value) {
    _id = value;
  }

  int get usuario_id => _usuario_id;
  set usuario_id(int value) {
    _usuario_id = value;
  }

  String get tipo_vehiculo => _tipo_vehiculo;
  set tipo_vehiculo(String value) {
    _tipo_vehiculo = value;
  }

  String get marca => _marca;
  set marca(String value) {
    _marca = value;
  }

  String get modelo => _modelo;
  set modelo(String value) {
    _modelo = value;
  }

  int get anio => _anio;
  set anio(int value) {
    _anio = value;
  }
}
