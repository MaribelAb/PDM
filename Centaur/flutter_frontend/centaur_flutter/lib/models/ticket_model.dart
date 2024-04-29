import 'package:centaur_flutter/models/user_model.dart';

class Ticket{
  int ? id;
  String ? token;
  String ? titulo;
  String ? descripcion;
  String ? solicitante;


  Ticket({
    this.titulo,
    this.descripcion,
    this.solicitante,
    this.id,
  });

  factory Ticket.fromJson(json){
    return Ticket(
      titulo: json["titulo"],
      descripcion: json["descripcion"],
      solicitante:json["solicitante"],
      id: json["id"],
    );
  }
}

