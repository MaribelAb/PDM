class Formulario {
  String titulo;
  String descripcion;
  List<Campo> campos;
  String categoria;
  bool oculto; 

  Formulario({
    required this.titulo,
    required this.descripcion,
    required this.campos,
    required this.categoria,
    required this.oculto,
  });

  factory Formulario.fromJson(Map<String, dynamic> json) {
    final titulo = json['titulo'];
    final descripcion = json['descripcion'];
    final camposJson = json['campos'] as List<dynamic>;
    final campos = camposJson.map((campoJson) => Campo.fromJson(campoJson)).toList();
    final categoria = json['categoria'];
    final oculto = json['oculto'];
    return Formulario(
      titulo: titulo,
      descripcion: descripcion,
      campos: campos,
      categoria: categoria,
      oculto:oculto
    );
  }
}


class Campo {
  final String nombre;
  final String tipo;
  final List<Opcion>? opciones;

  Campo({
    required this.nombre,
    required this.tipo,
    this.opciones,
  });

  factory Campo.fromJson(Map<String, dynamic> json) {
    final nombre = json['nombre'];
    final tipo = json['tipo'];
    final opcionesJson = json['opciones'] as List<dynamic>;
    final opciones = opcionesJson.map((opcionesJson) => Opcion.fromJson(opcionesJson)).toList();

    return Campo(
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
    final nombre = json['nombre'];
    final valor = json['valor'];

    return Opcion(
      nombre: nombre,
      valor: valor,
    );
  }
}
