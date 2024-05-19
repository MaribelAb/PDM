import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/formulario_model.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
/*import 'package:centaur_flutter/pages/create_form.dart';
import 'package:centaur_flutter/pages/create_form.dart';
import 'package:centaur_flutter/pages/form.dart';
import 'package:centaur_flutter/pages/modificarTicket.dart';
import 'package:centaur_flutter/pages/modifyForm.dart';*/
import 'package:flutter/material.dart';
//import 'tu_archivo.dart'; // Reemplaza "tu_archivo.dart" con el nombre de tu archivo que contiene la función getTickets

class FormList extends StatefulWidget {
  @override
  _FormListState createState() => _FormListState();
}

class _FormListState extends State<FormList> {
  List<Formulario> _formularios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadForms();
  }

  Future<void> _loadForms() async {
    try {
      List<Formulario> formularios = await obtenerFormularios();
      setState(() {
        _formularios = formularios;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los formularios (codigo): $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    late String estado;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Formularios'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _formularios.isEmpty
              ? Column(
                children: [
                  Center(child: Text('No hay formularios disponibles')),
                  
                ],
              )
              : ListView.builder(
                  itemCount: _formularios.length,
                  itemBuilder: (context, index) {
                    Formulario formulario = _formularios[index];
                    if(formulario.oculto == true){
                      estado = 'Este formulario está oculto';
                    }
                    else
                      estado = 'Este formulario está visible';
                    return ListTile(
                      leading: ElevatedButton(
                        onPressed: () {
                          if(formulario.oculto == true){
                            formulario.oculto = false;
                          }
                          else{
                            formulario.oculto = true;
                          }
                          setState(() { });  
                        },
                        child: Text('Mostrar/Ocultar'),
                      ),
                      title: Text(formulario.titulo),
                      subtitle: Text(estado),
                      trailing: ElevatedButton(
                        onPressed: () {
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ModifyFormPage(form: formulario)),
                          );*/
                        },
                        child: Text('Ver Formulario'),
                      ),
                    );
                  },
                ),
    );
  }
}
