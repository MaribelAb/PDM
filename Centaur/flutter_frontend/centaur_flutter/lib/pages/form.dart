

import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/ticket_cubit.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/pages/tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyForm());

class MyForm extends StatelessWidget {
  const MyForm({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController userController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Titulo"),
          TextFormField(
            controller: titleController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Text("Descripción"),
          TextFormField(
            controller: descriptionController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Text("Solicitante"),
          TextFormField(
            controller: userController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () async {
                var authRes = await sendForm(titleController.text, descriptionController.text, userController.text);
                if(authRes == false){
                  // ignore: use_build_context_synchronously
                  showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Ticket no se ha creado'),
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
                else{
                Ticket ticket = authRes as Ticket;
                context.read<TicketCubit>().emit(ticket);
                showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          title: Text('Operación Exitosa'),
                          content: Text('Ticket creado correctamente'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ListaTicketsPage(token: tokenBox)),
                                );
                              }, 
                              child: Text('Aceptar')
                            ),
                          ],
                        );
                      }
                    );  // 
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}