class Formulario {
  int id;
  String titulo;
  String descripcion;
  List<Campo> ?campos;
  String ?categoria;
  bool oculto; 

  Formulario({
    required this.titulo,
    required this.descripcion,
    required this.campos,
    required this.categoria,
    required this.oculto, required this.id,
  });

  factory Formulario.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? 0;
    final titulo = json['titulo'] ?? '';
    final descripcion = json['descripcion'] ?? '';
    final camposJson = json['campos'] as List<dynamic>;
    final campos = camposJson.map((campoJson) => Campo.fromJson(campoJson)).toList();
    final categoria = json['categoria'] ?? '';
    final oculto = json['oculto'] ?? true;
    return Formulario(
      id:id,
      titulo: titulo,
      descripcion: descripcion,
      campos: campos,
      categoria: categoria,
      oculto:oculto
    );
  }
}


class Campo {
  int id;
  late final String nombre;
  final String tipo;
  final List<Opcion>? opciones;

  Campo({
    required this.nombre,
    required this.tipo,
    this.opciones,
    required this.id,
  });

  factory Campo.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final nombre = json['nombre'] ?? '';
    final tipo = json['tipo'] ?? '';
    final opcionesJson = json['opciones'] as List<dynamic>;
    final opciones = opcionesJson.map((opcionesJson) => Opcion.fromJson(opcionesJson)).toList();

    return Campo(
      id : id,
      nombre : nombre,
      tipo : tipo,
      opciones: opciones,
    );
  }
}

class Opcion {
  final String nombre;
  final String valor;

  Opcion({
    required this.nombre,
    required this.valor,
  });

  factory Opcion.fromJson(Map<String, dynamic> json) {
    final nombre = json['nombre'] ?? '';
    final valor = json['valor'] ?? '';

    return Opcion(
      nombre: nombre,
      valor: valor,
    );
  }
}
