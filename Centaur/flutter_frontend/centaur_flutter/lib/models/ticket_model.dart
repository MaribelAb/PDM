import 'package:centaur_flutter/models/user_model.dart';

class Ticket{
  int ? id;
  String ? token;
  String ? titulo;
  String ? descripcion;
  String ? solicitante;
/*
class Ticket(models.Model):
    ALTA = 'alta'
    MEDIA = 'media'
    BAJA = 'baja'
    ABIERTO = 'abierto'
    EN_CURSO = 'en_curso'
    CERRADO = 'cerrado'
    PRIORIDADES = [
        (ALTA, "Alta"), (MEDIA, "Media"), (BAJA, "Baja")
    ]
    ESTADO =[
        (ABIERTO, "Abierto"), (EN_CURSO, "En curso"), (CERRADO, "Cerrado")
    ]
    titulo = models.CharField('Titulo', max_length = 100)
    descripcion = models.CharField('Descripcion', max_length = 100)
    solicitante = models.CharField('Solicitante', max_length = 100, blank=True)
    prioridad = models.CharField(max_length=6, choices=PRIORIDADES, blank=True)
    estado = models.CharField(max_length=10, choices=ESTADO, blank=True)
   # encargado = models.ForeignKey(
   #     "Agente",
   #     on_delete=models.CASCADE,
   # )
    #solicitante = models.ForeignKey(
    #    "Usuario",
    #    on_delete=models.CASCADE,
    #)
    fecha_ini = models.DateField(blank=True, null=True)
    fecha_fin = models.DateField(blank=True, null=True)
    conversacion = models.ForeignKey(
        "Chat",
        on_delete=models.CASCADE,
        blank=True,
        null=True,
    )
    nota = models.CharField('Nota', max_length = 100, blank=True, null=True)
    carpeta = models.CharField('Carpeta', max_length = 100, blank=True,null=True)
    categoria = models.CharField('Categoria', max_length = 100, blank=True,null=True)
    def __str__(self):
        return '{0}'.format(self.titulo)


*/

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

