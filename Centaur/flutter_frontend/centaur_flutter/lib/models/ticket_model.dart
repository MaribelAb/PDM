import 'package:centaur_flutter/models/user_model.dart';

class Ticket{
  int ? id;
  String ? token;
  String ? titulo;
  String ? descripcion;
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
    return Ticket(
      titulo: json["titulo"] ?? '',
      descripcion: json["descripcion"] ?? '',
      solicitante:json["solicitante"] ?? '',
      asignee : json['asignee'] ?? '',
      prioridad: json['prioridad']?? '',
      estado: json['estado'],
      fecha_creacion: json["fecha_creacion"]?? '',
      fecha_ini: json['fecha_ini']?? '',
      fecha_fin: json['fecha_fin']?? '',
      carpeta: json['carpeta']?? '',
      categoria: json['categoría']?? '',
      id: json["id"]?? '',
    );
  }
}

