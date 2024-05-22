import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/formulario_model.dart';
import 'package:centaur_flutter/pages/formList.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CreateForm());
}

List<Campo> formFields = [];
TextEditingController titulocontroller = TextEditingController();
TextEditingController descriptioncontroller = TextEditingController();
TextEditingController textfieldcontroller = TextEditingController();
TextEditingController optionscontroller = TextEditingController();
const List<String> list = ['Texto', 'Desplegable'];

class CreateForm extends StatelessWidget {
   String dropdownValue = list.first;
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
        if (formFields.isNotEmpty)
          ...formFields.map((campo) => buildCampoWidget(campo)).toList(),
        Row(
          children: [
            Text('Añade campo'),
            SizedBox(width: 10),
            Flexible(
              child: TextField(
                controller: textfieldcontroller,
                decoration: InputDecoration(helperText: 'Nombre del campo'),
              ),
            ),
            DropdownButton(
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
              onPressed: (){
                buildForm(dropdownValue);
              }, 
              child: Text('Añadir'),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () async {
            var authRes = await enviarDatosAlFormulario(
                titulocontroller.text, descriptioncontroller.text, formFields);
            if (authRes == false) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('Formulario no se ha guardado'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Aceptar'),
                      ),
                    ],
                  );
                },
              );
            } else{
              showDialog(
                context: context,
                builder: (context) {
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
                        child: Text('Aceptar'),
                      ),
                    ],
                  );
                },
              );
            }
          }, 
          child: Text('Guardar')
        ),
      ],
    );
  }
  
  void buildForm(String dropdownValue) {
    switch (dropdownValue){
      case 'Texto':
        formFields.add(
          Campo(
            nombre: textfieldcontroller.text, 
            tipo: 'Texto', id: 1)
        );
        setState(() {});
        break;  
      case 'Desplegable':
        List<Opcion> opt = [];
        showDialog(
          context: context, 
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Nombre del campo y opciones separadas por comas"),
              content: Column(
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
              actions: [
                TextButton(
                  onPressed: (){
                    final fieldName = textfieldcontroller.text;
                    var options = optionscontroller.text.split(',');
                    for (var i in options){
                      opt.add(
                        Opcion(
                          nombre: i, 
                          valor: i
                        )
                      );
                    }
                    formFields.add(
                      Campo(
                        nombre: fieldName, 
                        tipo: 'Desplegable',
                        opciones: opt,
                        id: 3
                      )
                    );
                    setState(() {});
                    Navigator.of(context).pop();
                  }, 
                  child: Text('Aceptar'),
                )
              ],
            );
          }
        );
        setState(() { });
        break;
      
    }
  }
}

Widget buildCampoWidget(Campo campo) {
    if (campo.tipo == 'Texto') {
      return Row(
        children: [
          Text(campo.nombre),
          Expanded(
            child: TextField()
          ),
        ],
      );
    } else if (campo.tipo == 'Desplegable') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(campo.nombre),
          SizedBox(height: 10),
          if (campo.opciones!.isNotEmpty) ...[
            DropdownButton(
            value: campo.opciones!.isNotEmpty ? campo.opciones!.first.valor : null,
            onChanged: (String? newValue) {},
            items: campo.opciones!.map<DropdownMenuItem<String>>((opcion) {
              return DropdownMenuItem<String>(
                value: opcion.valor,
                child: Text(opcion.nombre),
              );
            }).toList(),
          ),
          ] else ...[
            Text('No hay opciones disponibles'), 
          ],
        ],
      );
    } else {
      return SizedBox.shrink();
    }

}



