// ignore_for_file: use_build_context_synchronously

import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/formulario_model.dart';
import 'package:centaur_flutter/models/ticket_cubit.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/create_form.dart';
import 'package:centaur_flutter/pages/modifyForm.dart';
//import 'package:centaur_flutter/pages/form.dart';
//import 'package:centaur_flutter/pages/tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const RellenarForm());

class RellenarForm extends StatelessWidget {
  const RellenarForm({Key? key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Formulario';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: RellenarFormPage(form: Formulario(id:0,titulo: '', descripcion: '', campos: [], categoria: '', oculto: true)),
      ),
    );
  }
}

// Create a Form widget.
class RellenarFormPage extends StatefulWidget {
  final Formulario form;
  RellenarFormPage({Key? key, required this.form}) : super(key: key);

  @override
  RellenarFormPageState createState() => RellenarFormPageState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class RellenarFormPageState extends State<RellenarFormPage> {
  final _formKey = GlobalKey<FormState>();
  late Formulario formulario;
  late int? id;
  TextEditingController userController = TextEditingController();
  Map<int, TextEditingController> textControllers = {};
  Map<int, TextEditingController> dropdownControllers = {};

  @override
  void initState() {
    super.initState();
    formulario = widget.form;
    formulario.campos?.forEach((campo) {
    if (campo.tipo == 'Texto') {
      textControllers[campo.id] = TextEditingController();
    } else if (campo.tipo == 'Desplegable') {
      dropdownControllers[campo.id] = TextEditingController();
    }
  });
    
  }
  Map<int, String> extractTextValues(Map<int, TextEditingController> controllers) {
  return controllers.map((key, controller) => MapEntry(key, controller.text));
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    bool cliente = false;
    if (user.groups!.contains('Client')){
      cliente=true;
    }
    String buttonText = 'Modificar';
    if(cliente) buttonText = 'Enviar';  
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Column(
              children: [
                Text("Título: ${formulario.titulo}"),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                Text("Descripción: ${formulario.descripcion}"),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildCamposWidgets(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            
            child: ElevatedButton(
              onPressed: () async {
                if(cliente){
                  var campoTexto = extractTextValues(textControllers);
                  var campoDrop = extractTextValues(dropdownControllers);
                  var resp = await createTicket(formulario, user, campoTexto, campoDrop);
                  if(resp == true){
                    showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          title: Text('Correcto'),
                          content: Text('Ticket enviado correctamente. Siga el estado del ticket en "Mis tickets".'),
                          actions: [
                            ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              }, 
                              child: Text('Aceptar'),
                            )
                          ],
                        );
                      },
                    );
                  }else{
                    showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('No se ha podido crear el ticket'),
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
                }
                else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditFormPage(formFields: formulario.campos, formulario: formulario,)),
                  );
                }
              },
              child: Text(buttonText),
              
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCamposWidgets() {
    if (formulario.campos!.isNotEmpty) {
      return formulario.campos!.map((campo) {
        if (campo.tipo == 'Texto') {
          return TextFormField(
            controller: textControllers[campo.id],
            decoration: InputDecoration(
              labelText: campo.nombre,
            ),
          );
        } else if (campo.tipo == 'Desplegable') {
          return DropdownButtonFormField<Opcion>(
            items: campo.opciones!.map<DropdownMenuItem<Opcion>>((Opcion opcion) {
              return DropdownMenuItem<Opcion>(
                value: opcion,
                child: Text(opcion.nombre),
              );
            }).toList(),
            onChanged: (Opcion? opcionSeleccionada) {
              if (opcionSeleccionada != null) {
                dropdownControllers[campo.id]!.text = opcionSeleccionada.valor;
              }
            },
            decoration: InputDecoration(
              labelText: campo.nombre,
            ),
          );
        } else {
          return Text('Campo no compatible: ${campo.nombre}');
        }
      }).toList();
    } else {
      return [Text('No hay campos disponibles')];
    }
  }
}
