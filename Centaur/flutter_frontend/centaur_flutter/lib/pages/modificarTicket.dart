import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/ticket_cubit.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/pages/form.dart';
import 'package:centaur_flutter/pages/tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const ModifyTicket());

class ModifyTicket extends StatelessWidget {
  const ModifyTicket({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';
    
    

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: ModifyTicketPage(ticket: null),
      ),
    );
  }
}

// Create a Form widget.
class ModifyTicketPage extends StatefulWidget {
  final Ticket? ticket;
  ModifyTicketPage({super.key,required this.ticket});

  @override
  ModifyTicketPageState createState() {
    return ModifyTicketPageState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ModifyTicketPageState extends State<ModifyTicketPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  late Ticket? tick;
  late int? id;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController userController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    tick = widget.ticket;
    id = tick?.id;
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [        
          Card(
            child: Column (
              children: [
                Text("Antiguo Título: ${tick!.titulo}"),
                Text("Nuevo Título (vacío = titulo antiguo):"),
                TextFormField(
                  controller: titleController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      value = tick?.titulo;
                      
                    }
                    return null;
                  },
                ),
              ],
            )
          ),
          Card(
            child: Column(
              children: [
                Text("Antigua Descripción: ${tick!.descripcion}"),
                Text("Nueva Descripción"),
                TextFormField(
                  controller: descriptionController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      value = tick!.descripcion;
                    }
                
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String? title = titleController.text.isNotEmpty ? titleController.text : tick!.titulo;
                  String? description = descriptionController.text.isNotEmpty ? descriptionController.text : tick!.descripcion;
                  
                  var authRes = await modifyTicket(id!, title!, description!, tokenBox);
                  if(authRes){
                    showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          title: Text('Operación Exitosa'),
                          content: Text('Ticket modificado correctamente'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ListaTicketsPage(token: tokenBox,)),
                                );
                              }, 
                              child: Text('Aceptar')
                            ),
                          ],
                        );
                      }
                    );
                  }
                  else {
                    showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Ha ocurrido un error al modificar el ticket'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              }, 
                              child: Text('Aceptar')
                            ),
                          ],
                        );
                      }
                    );
                  }
                }
              },
              child: const Text('Modificar'),
            ),
          ),
        ],
      ),
    );
  }
}