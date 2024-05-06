class Formulario {
  final String titulo;
  final String descripcion;
  final List<Campo> campos;

  Formulario({
    required this.titulo,
    required this.descripcion,
    required this.campos,
  });

  factory Formulario.fromJson(Map<String, dynamic> json) {
    // Aquí conviertes el JSON en instancias de objetos Formulario
    // Extrae los datos necesarios del JSON y crea una nueva instancia de Formulario
    final titulo = json['titulo'];
    final descripcion = json['descripcion'];
    final camposJson = json['campos'] as List<dynamic>;
    final campos = camposJson.map((campoJson) => Campo.fromJson(campoJson)).toList();

    return Formulario(
      titulo: titulo,
      descripcion: descripcion,
      campos: campos,
    );
  }
}


class Campo {
  final String nombre;
  final String tipo;
  final List<Opcion>? opciones; // Opciones solo si el campo es de tipo desplegable

  Campo({
    required this.nombre,
    required this.tipo,
    this.opciones,
  });

  factory Campo.fromJson(Map<String, dynamic> json) {
    // Aquí conviertes el JSON en instancias de objetos Formulario
    // Extrae los datos necesarios del JSON y crea una nueva instancia de Formulario
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
    // Aquí conviertes el JSON en instancias de objetos Formulario
    // Extrae los datos necesarios del JSON y crea una nueva instancia de Formulario
    final nombre = json['nombre'];
    final valor = json['valor'];

    return Opcion(
      nombre: nombre,
      valor: valor,
    );
  }
}
