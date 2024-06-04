import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/tarea_model.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/home/admin_home.dart';
import 'package:centaur_flutter/pages/home/agent_home.dart';
import 'package:centaur_flutter/pages/ticketList.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TareaView extends StatefulWidget {
  final Tarea tarea;
 

  TareaView({Key? key, required this.tarea}) : super(key: key);

  @override
  _TareaViewState createState() => _TareaViewState();
}

class _TareaViewState extends State<TareaView> {
  late List<Tarea> _tareas;
  bool _isLoading = true;
  late Tarea tarea;
  late int? id;
  String? asignee;
  String? estado;
  String? prioridad;
  List<String> dropdownItems = [];
  bool misTickets = false;

  @override
  void initState() {
    super.initState();
    tarea = widget.tarea;
  }

  
  

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    return Scaffold(
      appBar: AppBar(title: Text(tarea.titulo, style: tituloStyle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título: ${tarea.titulo}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Descripción: ${tarea.descripcion}'),
            SizedBox(height: 8),
            Text('Fecha de inicio: ${tarea.fecha_ini.toString()}'),
            SizedBox(height: 8),
            Text('Fecha de fin: ${tarea.fecha_fin.toString()}'),
               
            ElevatedButton(
              onPressed: () async {
                // Call the function to modify the ticket with the selected values
                var resp = true;

                if (resp){
                  showDialog(
                    context: context, 
                    builder: (context){
                        return AlertDialog(
                          title: Text('Exito'),
                          content: Text('Tarea modificada correctamente'),
                          actions: [
                            ElevatedButton(
                              onPressed: (){
                                if (user.groups!.contains('Agent')){
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AgentHome()
                                  ),
                                );
                                }
                                else{
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminHome()
                                  ),
                                );
                                }
                                
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
                          content: Text('No se ha podido modificar la tarea'),
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

