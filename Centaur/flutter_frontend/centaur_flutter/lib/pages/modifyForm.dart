import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/formulario_model.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(EditFormPage(formFields: [], formulario: null,));

class EditFormPage extends StatefulWidget {
  final List<Campo>? formFields;
  Formulario? formulario;

  EditFormPage({required this.formFields, required this.formulario});

  @override
  _EditFormPageState createState() => _EditFormPageState();
}

class _EditFormPageState extends State<EditFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Formulario', style: tituloStyle(context))),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = widget.formFields?.removeAt(oldIndex);
                  widget.formFields?.insert(newIndex, item!);
                });
              },
              children: widget.formFields!.asMap()
                  .map((index, campo) => MapEntry(index, buildEditableCampoWidget(campo, index)))
                  .values
                  .toList(),
            ),
          ),
          ElevatedButton(
            
            onPressed: () async {
              bool success = await updateFormFields(widget.formulario, widget.formFields);
              if (success) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Operación Exitosa'),
                      content: Text('Formulario actualizado correctamente'),
                      actions: [
                        TextButton(
                          
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('No se ha podido actualizar el formulario'),
                      actions: [
                        TextButton(
                          
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Text('Guardar Cambios'),
          ),
        ],
      ),
    );
  }

  Widget buildEditableCampoWidget(Campo campo, int index) {
    return ListTile(
      key: ValueKey(index),
      title: TextField(
        controller: TextEditingController(text: campo.nombre),
        onChanged: (newValue) {
          setState(() {
            campo.nombre = newValue;
          });
        },
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        iconSize: 24,
        onPressed: () {
          setState(() {
            widget.formFields?.removeAt(index);
          });
        },
      ),
    );
  }
}
