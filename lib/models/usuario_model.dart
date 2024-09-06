class Usuario {
  int _id;
  String _nombre;
  String _apellido;
  String _email;
  String _telefono;
  String? _ubicacionActual; // Solo para mecánicos
  String _tipoUsuario; // 'cliente', 'mecánico', 'administrador'
  String? _habilidades; // 'auto', 'moto', 'ambos'
  bool? _disponibilidad; // Solo para mecánicos
  DateTime _fechaRegistro;

  // Constructor
  Usuario({
    required int id,
    required String nombre,
    required String apellido,
    required String email,
    required String telefono,
    required String tipoUsuario,
    String? habilidades,
    bool? disponibilidad,
    String? ubicacionActual,
    required DateTime fechaRegistro,
  })  : _id = id,
        _nombre = nombre,
        _apellido = apellido,
        _email = email,
        _telefono = telefono,
        _tipoUsuario = tipoUsuario,
        _habilidades = habilidades,
        _disponibilidad = disponibilidad,
        _ubicacionActual = ubicacionActual,
        _fechaRegistro = fechaRegistro;

  // Getters
  int get id => _id;
  String get nombre => _nombre;
  String get apellido => _apellido;
  String get email => _email;
  String get telefono => _telefono;
  String get tipoUsuario => _tipoUsuario;
  String? get habilidades => _habilidades;
  bool? get disponibilidad => _disponibilidad;
  String? get ubicacionActual => _ubicacionActual;
  DateTime get fechaRegistro => _fechaRegistro;

  // Setters
  set nombre(String nombre) {
    _nombre = nombre;
  }

  set apellido(String apellido) {
    _apellido = apellido;
  }

  set email(String email) {
    _email = email;
  }

  set telefono(String telefono) {
    _telefono = telefono;
  }

  set tipoUsuario(String tipoUsuario) {
    if (tipoUsuario == 'cliente' || tipoUsuario == 'mecánico' || tipoUsuario == 'administrador') {
      _tipoUsuario = tipoUsuario;
    } else {
      throw Exception('Tipo de usuario inválido');
    }
  }

  set habilidades(String? habilidades) {
    _habilidades = habilidades;
  }

  set disponibilidad(bool? disponibilidad) {
    _disponibilidad = disponibilidad;
  }

  set ubicacionActual(String? ubicacionActual) {
    _ubicacionActual = ubicacionActual;
  }

  // Método para convertir un mapa a Usuario
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      email: map['email'],
      telefono: map['telefono'],
      tipoUsuario: map['tipo_usuario'],
      habilidades: map['habilidades'],
      disponibilidad: map['disponibilidad'],
      ubicacionActual: map['ubicacion_actual'],
      fechaRegistro: DateTime.parse(map['fecha_registro']),
    );
  }

  // Método para convertir Usuario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'nombre': _nombre,
      'apellido': _apellido,
      'email': _email,
      'telefono': _telefono,
      'tipo_usuario': _tipoUsuario,
      'habilidades': _habilidades,
      'disponibilidad': _disponibilidad,
      'ubicacion_actual': _ubicacionActual,
      'fecha_registro': _fechaRegistro.toIso8601String(),
    };
  }
}
