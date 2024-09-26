class Usuario {
  int? _id;
  String? _contrasenia;
  String _nombre;
  String? _apellido;
  String _email;
  String? _url_foto;
  String? _telefono;
  String? _fecha_registro;
  String? _ultimo_inicio_sesion;
  String? _ubicacionActual; // Solo para mecánicos
  String? _tipoUsuario; // 'cliente', 'mecánico', 'administrador'
  bool? _estado;
  String? _habilidades; // 'auto', 'moto', 'ambos'
  bool? _disponibilidad; // Solo para mecánicos

  // Constructor
  Usuario({
    int? id,
    String? contrasenia,
    required String nombre,
    String? apellido,
    required String email,
    String? url_foto,
    String? telefono,
    String? fecha_registro,
    String? ultimo_inicio_sesion,
    String? ubicacionActual,
    String? tipoUsuario,
    bool? estado,
    String? habilidades,
    bool? disponibilidad,
  })  : _id = id,
        _contrasenia = contrasenia,
        _nombre = nombre,
        _apellido = apellido,
        _email = email,
        _url_foto = url_foto,
        _telefono = telefono,
        _fecha_registro = fecha_registro,
        _ultimo_inicio_sesion = ultimo_inicio_sesion,
        _ubicacionActual = ubicacionActual,
        _tipoUsuario = tipoUsuario,
        _estado = estado,
        _habilidades = habilidades,
        _disponibilidad = disponibilidad;

  // Getters
  int? get id => _id;
  String? get contrasenia => _contrasenia;
  String get nombre => _nombre;
  String? get apellido => _apellido;
  String get email => _email;
  String? get url_foto => _url_foto;
  String? get telefono => _telefono;
  String? get fecha_registro => _fecha_registro;
  String? get ultimo_inicio_sesion => _ultimo_inicio_sesion;
  String? get ubicacionActual => _ubicacionActual;
  String? get tipoUsuario => _tipoUsuario;
  bool? get estado => _estado;
  String? get habilidades => _habilidades;
  bool? get disponibilidad => _disponibilidad;

  // Setters
  set contrasenia(String? value) => _contrasenia = value;
  set nombre(String value) => _nombre = value;
  set apellido(String? value) => _apellido = value;
  set email(String value) => _email = value;
  set url_foto(String? value) => _url_foto = value;
  set telefono(String? value) => _telefono = value;
  set fecha_registro(String? value) => _fecha_registro = value;
  set ultimo_inicio_sesion(String? value) => _ultimo_inicio_sesion = value;
  set ubicacionActual(String? value) => _ubicacionActual = value;
  set tipoUsuario(String? value) => _tipoUsuario = value;
  set estado(bool? value) => _estado = value;
  set habilidades(String? value) => _habilidades = value;
  set disponibilidad(bool? value) => _disponibilidad = value;
// Método para convertir de JSON a una instancia de Usuario
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      contrasenia: json['contrasenia'] as String?,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String?,
      email: json['email'] as String,
      url_foto: json['url_foto'] as String?,
      telefono: json['telefono'] as String?,
      fecha_registro: json['fecha_registro'] as String,
      ultimo_inicio_sesion: json['ultimo_inicio_sesion'] as String,
      ubicacionActual: json['ubicacionActual'] as String?,
      tipoUsuario: json['tipo_usuario'] as String,
      estado: json['estado']==1,
      habilidades: json['habilidades'] as String?,
      disponibilidad: json['disponibilidad']==1,
    );
  }

}
