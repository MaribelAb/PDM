import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/formulario_model.dart';
import 'package:centaur_flutter/pages/formList.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CreateForm());
}

const List<String> list = ['Texto', 'Desplegable'];
List<Campo> formFields = [];
TextEditingController textfieldcontroller = TextEditingController();
TextEditingController optionscontroller = TextEditingController();
TextEditingController titulocontroller = TextEditingController();
TextEditingController descriptioncontroller = TextEditingController();
List<TextEditingController> opt = [];
List<String> opciones = [];

class CreateForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Nuevo formulario')),
        body: TextFieldManager(),
      ),
    );
  }
}

class TextFieldManager extends StatefulWidget {
  @override
  _TextFieldManagerState createState() => _TextFieldManagerState();
}

class _TextFieldManagerState extends State<TextFieldManager> {
  String dropdownValue = list.first;
                List<Campo> campos = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: titulocontroller,
          decoration: InputDecoration(hintText: 'Título'),
        ),
        TextField(
          controller: descriptioncontroller,
          decoration: InputDecoration(hintText: 'Descripción'),
        ),
        if (formFields.isNotEmpty) ...formFields,
        
        Row(
          children: [
            Text('Añade campo'),
            SizedBox(width: 10),
            Flexible(
              child: TextField(
                controller: textfieldcontroller,
                decoration:
                    InputDecoration(helperText: 'Nombre del campo'),
              ),
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                buildForm(dropdownValue);
              },
              child: Text("Añade"),
            ),
          ],
        ),
        ElevatedButton(
              onPressed: () async {
                for (Widget field in formFields) {
                    if (field is Row) {
                        // Si es un Row, asumimos que contiene un TextField
                        final textField = field.children.first as TextField;
                        campos.add(Campo(nombre: textField.controller!.text, tipo: 'Texto'));
                    } else if (field is Column) {
                        // Si es una Columna, asumimos que contiene un DropdownButton
                        final dropdownButton = field.children.first as DropdownButton<String>;
                        final fieldName = dropdownButton.hint.toString();
                        final options = dropdownButton.items!.map((item) => item.value!).toList();
                        campos.add(Campo(nombre: fieldName, tipo: 'Desplegable', opciones: options.map((option) => Opcion(nombre: option, valor: option)).toList()));
                    }
                }
                print('CAMPOS: $campos');
                var authRes = await enviarDatosAlFormulario(titulocontroller.text, descriptioncontroller.text, campos);
                if(authRes == false){
                  showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Formulario no se ha guardado'),
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
                  showDialog(
                    context: context, 
                    builder: (context){
                      return AlertDialog(
                        title: Text('Operación Exitosa'),
                        content: Text('Formulario guardado correctamente'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FormList()),
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
              child: Text("Guardar"),
            ),
      ],
    );
  }

  void buildForm(String opcion) {
  switch (opcion) {
    case 'Texto':
      formFields.add(addTextField(textfieldcontroller.text));
      print(formFields);
      setState(() {});
      break;
    case 'Desplegable':
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Nombre del campo y opciones separadas por comas"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textfieldcontroller,
                  decoration: InputDecoration(helperText: 'Nombre del campo'),
                ),
                TextField(
                  controller: optionscontroller,
                  decoration: InputDecoration(helperText: 'Opciones'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  final fieldName = textfieldcontroller.text;
                  final options = optionscontroller.text.split(',');
                  formFields.add(addDropDown(fieldName, options));
                  print(formFields);
                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
      break;
    }
  }

}

Widget addTextField(String nom) {
  return Row(
    children: [
      Text(nom),
      SizedBox(width: 10),
      Expanded(
        child: TextField()
      ),
    ],
  );
}

Widget addDropDown(String fieldName, List<String> opciones) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(fieldName),
      SizedBox(height: 10),
      if (opciones.isNotEmpty) ...[
        DropdownButton<String>(
          value: opciones.first ?? '', // Si opciones.first es null, se usa una cadena vacía como valor predeterminado
          onChanged: (String? newValue) {},
          items: opciones.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ] else ...[
        Text('No hay opciones disponibles'), // Agregar un mensaje si no hay opciones disponibles
      ],
    ],
  );
}