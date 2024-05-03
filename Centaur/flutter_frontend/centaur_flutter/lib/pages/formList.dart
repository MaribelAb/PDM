import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(formList());
}

class formList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Lista Formularios (por crear)')),
      ),
    );
  }
  
}
