import 'package:centaur_flutter/models/user_model.dart';

class Tarea{
  String titulo;
  String descripcion;
  String ? creador;
  DateTime ? fecha_ini;
  DateTime ? fecha_fin;
  DateTime ? hora_ini;
  DateTime ? hora_fin;

  Tarea({
    required this.titulo,
    required this.descripcion,
    this.creador,
    required this.fecha_ini,
    required this.fecha_fin,
    this.hora_ini,
    this.hora_fin,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    final titulo = json['titulo'] ?? '';
    final descripcion = json['descripcion'] ?? '';
    final creador = json['creador'] ?? '';
    final fecha_ini = json['fecha_ini'] != null ? DateTime.parse(json['fecha_ini']) : null;
    final fecha_fin = json['fecha_fin'] != null ? DateTime.parse(json['fecha_fin']) : null;
    final hora_ini = json['hora_ini'] != null ? DateTime.parse('1970-01-01T${json['hora_ini']}') : null;
    final hora_fin = json['hora_fin'] != null ? DateTime.parse('1970-01-01T${json['hora_fin']}') : null;

    return Tarea(
      titulo: titulo,
      descripcion: descripcion,
      creador: creador,
      fecha_ini: fecha_ini,
      fecha_fin: fecha_fin,
      hora_ini: hora_ini,
      hora_fin: hora_fin,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'creador': creador,
      'fecha_ini': fecha_ini?.toIso8601String(),
      'fecha_fin': fecha_fin?.toIso8601String(),
      'hora_ini': hora_ini?.toIso8601String(),
      'hora_fin': hora_fin?.toIso8601String(),
    };
  }
}