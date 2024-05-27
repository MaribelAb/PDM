import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/ticketList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketViewPage extends StatefulWidget {
  final Ticket ticket;
 

  TicketViewPage({Key? key, required this.ticket}) : super(key: key);

  @override
  _TicketViewPageState createState() => _TicketViewPageState();
}

class _TicketViewPageState extends State<TicketViewPage> {
  List<String?>? _agentes = [];
  Map<String, dynamic> _choices = {};
  bool _isLoading = true;
  late Ticket ticket;
  late int? id;
  String? asignee;
  String? estado;
  String? prioridad;
  List<String> dropdownItems = [];
  bool misTickets = false;

  @override
  void initState() {
    super.initState();
    _getAgentes();
    _getTicketChoices();
    ticket = widget.ticket;
  }

  Future<void> _getAgentes() async {
    try {
      List<String?>? agentes = await getAgentUsers();
      setState(() {
        _agentes = agentes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los usuarios (codigo): $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future <void> _getTicketChoices() async {
    try {
      Map<String, dynamic> choices = await getTicketChoices();
      setState(() {
        _choices = choices;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los choices (codigo): $e');
      setState(() {
        _isLoading = false;
      });
    }
    
  }

  

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    return Scaffold(
      appBar: AppBar(title: Text('Ticket Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título: ${ticket.titulo}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Descripción: ${ticket.descripcion}'),
            SizedBox(height: 8),
            if (ticket.contenido != null && ticket.contenido!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contenido:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: ticket.contenido!.length,
                    itemBuilder: (context, index) {
                      final contenido = ticket.contenido![index];
                      return Text('${contenido.nombre}: ${contenido.valor}');
                    },
                  ),
                ]
              ),
            Text('Solicitante: ${ticket.solicitante}'),
            SizedBox(height: 8),
            Text('Responsable: ${ticket.asignee}'),
            if(user.groups!.contains('Client') == false)            
            DropdownButtonFormField<String>(
              value: asignee,
              onChanged: (value) {
                setState(() {
                  asignee = value;
                });
              },
              items: _agentes?.map((username) {
                return DropdownMenuItem<String>(
                  value: username,
                  child: Text(username!),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Nuevo responsable'),
            ),
            if(user.groups!.contains('Client') == false)      
            Text('Prioridad: ${ticket.prioridad}'),
            if(user.groups!.contains('Client') == false)  
            DropdownButtonFormField<String>(
              value: prioridad,
              onChanged: (value) {
                setState(() {
                  prioridad = value;
                });
              },
              items: _choices['prioridades'] != null
                  ? _choices['prioridades'].map<DropdownMenuItem<String>>((dynamic value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  : [],
              decoration: InputDecoration(labelText: 'Nueva prioridad'),
            ),
                
            Text('Estado: ${ticket.estado}'),
            if(user.groups!.contains('Client') == false)  
            DropdownButtonFormField<String>(
              value: estado,
              onChanged: (value) {
                setState(() {
                  estado = value;
                });
              },
              items: _choices['estados'] != null
                  ? _choices['estados'].map<DropdownMenuItem<String>>((dynamic value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  : [],
              decoration: InputDecoration(labelText: 'Nuevo estado'),
            ),

            SizedBox(height: 8),
            if(user.groups!.contains('Client') == false)      
            ElevatedButton(
              onPressed: () async {
                // Call the function to modify the ticket with the selected values
                var resp = await modifyTicket(
                  ticket,
                  ticket.id,
                  ticket.titulo,
                  ticket.descripcion,
                  asignee,
                  prioridad,
                  estado,
                );

                if (resp){
                  showDialog(
                    context: context, 
                    builder: (context){
                        return AlertDialog(
                          title: Text('Exito'),
                          content: Text('Ticket modificado correctamente'),
                          actions: [
                            ElevatedButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TicketList(misTickets: misTickets,)
                                  ),
                                );
                              }, 
                              child: Text('Aceptar'),
                            )
                          ],
                        );
                      }
                  );
                } else{
                  showDialog(
                    context: context, 
                    builder: (context){
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('No se ha podido modificar el ticket'),
                          actions: [
                            ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              }, 
                              child: Text('Aceptar'),
                            )
                          ],
                        );
                      }
                  );
                }
              },
              child: Text('Modificar'),
            )
          ],
        ),
      ),
    );
  }
}

