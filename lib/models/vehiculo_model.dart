class Vehiculo {
  int _id;
  int _usuario_id; // dueño del vehículo (usuario)
  String _clase_vehiculo; // Puede ser 'auto' o 'moto'
  String _marca;
  String _modelo;
  String _placa; 
  String _tipo;
  String _cilindrada;
  int _estado_db;
  String? _foto;
  String? _color;
  String? _combustible;
  String? _tipo_motor;

  // Constructor
  Vehiculo({
    required int id,//1
    required int usuario_id,//1
    required String clase_vehiculo,//Moto
    required String marca,//Zeus
    required String modelo,//2022
    required String placa,//6092txt
    required String tipo,//TITANIUM
    required String cilindrada,//200
    required int estado_db,
    String? color,
    String? combustible,
    String? tipo_motor,
    String? foto,

  })  : _id = id,
        _usuario_id = usuario_id,
        _clase_vehiculo = clase_vehiculo,
        _marca = marca,
        _modelo = modelo,
        _placa = placa,
        _tipo = tipo,
        _cilindrada=cilindrada,
        _estado_db=estado_db,
        _color=color,
        _combustible=combustible,
        _tipo_motor=tipo_motor,
        _foto=foto;

  // Constructor 2
  Vehiculo.vacio({int usuario_id = 0})  : 
        _id = 0,
        _usuario_id = usuario_id,
        _clase_vehiculo = "moto",
        _marca = "",
        _modelo = "",
        _placa = "",
        _tipo = "",
        _cilindrada = "",
        _estado_db = 1,
        _color = "",
        _combustible = "",
        _tipo_motor = "",
        _foto = "";

  // Método para convertir de un Map a un objeto Vehiculo
  factory Vehiculo.fromMap(Map<String, dynamic> map) {
    return Vehiculo(
      id: map['id'],
      usuario_id: map['usuario_id'],
      clase_vehiculo: map['clase_vehiculo'],
      marca: map['marca'],
      modelo: map['modelo'],
      placa: map['placa'],
      tipo: map['tipo'],
      cilindrada: map['cilindrada'],
      estado_db: map['estado_db'],
      color: map['color'],
      combustible: map['combustible'],
      tipo_motor: map['tipo_motor'],
      foto: map['foto']
    );
  }

  // Método para convertir un objeto Vehiculo a un Map (para guardar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'usuario_id': _usuario_id,
      'clase_vehiculo': _clase_vehiculo,
      'marca': _marca,
      'modelo': _modelo,
      'placa': _placa,
      'tipo': _tipo,
      'cilindrada': _cilindrada,
      'estado_db': _estado_db,
      'color':_color,
      'combustible':_combustible,
      'tipo_motor':_tipo_motor,
      'foto': _foto
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

  String get clase_vehiculo => _clase_vehiculo;
  set clase_vehiculo(String value) {
    _clase_vehiculo = value;
  }

  String get marca => _marca;
  set marca(String value) {
    _marca = value;
  }

  String get modelo => _modelo;
  set modelo(String value) {
    _modelo = value;
  }

  String get placa => _placa;
  set placa(String value) {
    _placa = value;
  }
  String get tipo => _tipo;
  set tipo(String value) {
    _tipo = value;
  }
  String get cilindrada => _cilindrada;
  set cilindrada(String value) {
    _cilindrada = value;
  }
  int get estado_db => _estado_db;
  set estado_db(int value) {
    _estado_db = value;
  }
  String? get color => _color;
  set color(String? value) {
    _color = value;
  }
  String? get combustible => _combustible;
  set combustible(String? value) {
    _combustible = value;
  }
  String? get tipo_motor => _tipo_motor;
  set tipo_motor(String? value) {
    _tipo_motor = value;
  }
  String? get foto => _foto;
  set foto(String? value) {
    _foto = value;
  }
}
