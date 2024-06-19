import 'package:centaur_flutter/models/user_model.dart';

class Ticket{
  int ? id;
  String ? token;
  String ? titulo;
  String ? descripcion;
  List<Contenido> ?contenido;
  String ? solicitante;
  String ? asignee;
  String ? prioridad;
  String ? estado;
  DateTime ? fecha_creacion;
  DateTime ? fecha_ini;
  DateTime ? fecha_fin;
  String ? carpeta;
  String ? categoria;


  Ticket({
    this.titulo,
    this.descripcion,
    this.contenido,
    this.solicitante,
    this.fecha_creacion,
    this.id,
    this.asignee,
    this.carpeta,
    this.categoria,
    this.estado,
    this.fecha_fin,
    this.fecha_ini,
    this.prioridad,
  });

  factory Ticket.fromJson(json){

    List<Contenido>? contenidoList;
  if (json['contenido'] != null) {
    if (json['contenido'] is List) {

      contenidoList = (json['contenido'] as List)
          .map((contenidoJson) => Contenido.fromJson(contenidoJson))
          .toList();
    } else {
      contenidoList = [Contenido.fromJson(json['contenido'])];
    }
  }
    
      final titulo = json["titulo"] ?? '';
      final descripcion = json["descripcion"] ?? '';
      final contenido = contenidoList;
      final solicitante = json["solicitante"] ?? '';
      final asignee = json['encargado'] ?? '';
      final prioridad = json['prioridad']?? '';
      final estado = json['estado'];
      final fecha_creacion = json["fecha_creacion"] != null ? DateTime.parse(json["fecha_creacion"]) : null;
      final fecha_ini = json['fecha_ini'] != null ? DateTime.parse(json['fecha_ini']) : null;
      final fecha_fin = json['fecha_fin'] != null ? DateTime.parse(json['fecha_fin']) : null;
      final carpeta = json['carpeta'] ?? '';
      final categoria = json['categoria'] ?? '';
      final id = json["id"] ?? '';
    return Ticket(
      id: id,
      titulo: titulo,
      descripcion: descripcion,
      contenido: contenido,
      solicitante: solicitante,
      asignee: asignee,
      prioridad: prioridad,
      estado: estado,
      fecha_creacion: fecha_creacion,
      fecha_ini: fecha_ini,
      fecha_fin: fecha_fin,
      carpeta: carpeta,
      categoria: categoria,
    );
  }
}

class Contenido{
  String ? nombre;
  String ? valor;

  Contenido({
    required this.nombre,
    required this.valor
  });

  factory Contenido.fromJson(Map<String, dynamic> json){
    final nombre = json['nombre'] ?? '';
    final valor = json['valor'] ?? '';
    return Contenido(
      nombre:nombre,
      valor:valor
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'valor': valor,
    };
  }
}