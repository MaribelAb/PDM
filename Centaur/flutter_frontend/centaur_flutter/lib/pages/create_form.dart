import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/pages/formList.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CreateForm());
}

const List<String> list = ['Texto', 'Desplegable'];
List<Widget> formFields = [];
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
                var authRes = await enviarDatosAlFormulario(titulocontroller.text, descriptioncontroller.text, formFields);
                if(authRes == false){
                  // ignore: use_build_context_synchronously
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
                                  MaterialPageRoute(builder: (context) => formList()),
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
                    decoration:
                        InputDecoration(helperText: 'Nombre del campo'),
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
                    formFields.add(addDropDown(
                      textfieldcontroller.text,
                      optionscontroller.text.split(','),
                    ));
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
      Expanded(child: TextField()),
    ],
  );
}

Widget addDropDown(String fieldName, List<String> opciones) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(fieldName),
      SizedBox(height: 10),
      DropdownButton<String>(
        value: opciones.first,
        onChanged: (String? newValue) {},
        items: opciones.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    ],
  );
}
