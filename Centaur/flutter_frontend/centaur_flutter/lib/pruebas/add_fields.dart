import 'package:flutter/material.dart';

void main() {
  runApp(AddFields());
}

const List<String> list = ['Texto', 'Desplegable'];
List<Widget> formFields = [];
TextEditingController textfieldcontroller = TextEditingController();
TextEditingController optionscontroller = TextEditingController();
List<TextEditingController> opt = [];
List<String> opciones = [];

class AddFields extends StatelessWidget {
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
          decoration: InputDecoration(hintText: 'Título'),
        ),
        TextField(
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
        )
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
