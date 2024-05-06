import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/formulario_model.dart';
import 'package:centaur_flutter/models/ticket_cubit.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/pages/create_form.dart';
import 'package:centaur_flutter/pages/form.dart';
import 'package:centaur_flutter/pages/tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const ModifyForm());

class ModifyForm extends StatelessWidget {
  const ModifyForm({Key? key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Formulario';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: ModifyFormPage(form: Formulario(titulo: '', descripcion: '', campos: [])),
      ),
    );
  }
}

// Create a Form widget.
class ModifyFormPage extends StatefulWidget {
  final Formulario form;
  ModifyFormPage({Key? key, required this.form}) : super(key: key);

  @override
  ModifyFormPageState createState() => ModifyFormPageState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class ModifyFormPageState extends State<ModifyFormPage> {
  final _formKey = GlobalKey<FormState>();
  late Formulario formulario;
  late int? id;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController userController = TextEditingController();

  @override
  void initState() {
    super.initState();
    formulario = widget.form;
    //id = formulario?.id;
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () async {},
              child: const Text('Enviar'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCamposWidgets() {
    if (formulario.campos != null && formulario.campos.isNotEmpty) {
      return formulario.campos.map((campo) {
        if (campo.tipo == 'Texto') {
          return TextFormField(
            initialValue: campo.nombre,
            readOnly: true,
            decoration: InputDecoration(
              labelText: campo.nombre,
            ),
          );
        } else if (campo.tipo == 'Desplegable') {
            Campo campoDesplegable = campo;
            return DropdownButtonFormField<Opcion>(
              items: campoDesplegable.opciones?.map<DropdownMenuItem<Opcion>>((Opcion opcion) {
                return DropdownMenuItem<Opcion>(
                  value: opcion,
                  child: Text(opcion.nombre),
                );
              }).toList(),
              onChanged: (Opcion? opcionSeleccionada) {
                // Implementa la lógica para manejar la opción seleccionada
              },
              decoration: InputDecoration(
                labelText: campo.nombre,
              ),
            );
          }
          else {
          // Otro tipo de campo
          return Text('Campo no compatible: ${campo.nombre}');
        }
      }).toList();
    } else {
      return [Text('No hay campos disponibles')];
    }
  }
}
