import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/formulario_model.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/create_form.dart';
import 'package:centaur_flutter/pages/formSearch.dart';
/*import 'package:centaur_flutter/pages/create_form.dart';
import 'package:centaur_flutter/pages/form.dart';
import 'package:centaur_flutter/pages/modificarTicket.dart';*/
import 'package:centaur_flutter/pages/rellenarForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'tu_archivo.dart'; // Reemplaza "tu_archivo.dart" con el nombre de tu archivo que contiene la función getTickets

class FormList extends StatefulWidget {
  String s;
  FormList(this.s, {super.key});
  

  @override
  _FormListState createState() => _FormListState(s);
}



class _FormListState extends State<FormList> {
  List<Formulario> _formularios = [];
  bool _isLoading = true;
  String loc = '';
  
  _FormListState(String s);
  TextEditingController search = new TextEditingController();
  
  

  @override
  void initState() {
    super.initState();
    _loadForms();
    loc = widget.s;
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
    String sub;
    User user = context.read<UserCubit>().state;
    bool cliente = false;
    if (user.groups!.contains('Client')){
      cliente = true;
    }
    List<Formulario> filteredFormularios = [];
    if(cliente){
      filteredFormularios = _formularios.where((formulario) => !formulario.oculto).toList();
       _formularios = filteredFormularios;
    }
    if(loc == 'Comunicacion'){
      _formularios = filteredFormularios.where((formulario) => formulario.categoria == 'Comunicacion').toList();
    } else if(loc == 'Incidencias'){
      _formularios = filteredFormularios.where((formulario) => formulario.categoria == 'Incidencias').toList();
    } else if(loc == 'Quejas'){
      _formularios = filteredFormularios.where((formulario) => formulario.categoria == 'Quejas').toList();
    }
      
    
   
      
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
              : Column(
                children: [
                  SearchBar(
                    hintText: 'Introduce el término de búsqueda',
                    controller: search,
                    leading: IconButton(icon: Icon(Icons.search), onPressed: (){
                      Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FormSearch(clave: search.text)),
                              );
                    }, ),
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _formularios.length,
                        itemBuilder: (context, index) {
                          Formulario formulario = _formularios[index];
                         
                            
                          if(formulario.oculto == true){
                            estado = 'Este formulario está oculto';
                          }
                          else
                            estado = 'Este formulario está visible';
                          
                          if(cliente){sub = formulario.descripcion;}
                            
                          else{sub=estado;}
                          return ListTile(
                            
                            leading: Visibility(
                              visible: !cliente, // Show if cliente is false
                              child: ElevatedButton(
                                onPressed: () async {
                                  var resp = await editarVisibilidad(formulario);
                                  if(resp){
                                    AlertDialog(
                                      title: Text('Correcto'),
                                      content: Text('Visibilidad cambiada de forma exitosa'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Aceptar'),
                                        ),
                                      ],
                                    );
                                    setState(() { });
                                  }
                                  else{
                                    AlertDialog(
                                      title: Text('Error'),
                                      content: Text('No se ha podido cambiar la visibilidad'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Aceptar'),
                                        ),
                                      ],
                                    );
                                  }
                                },
                                child: Text(formulario.oculto ? 'Mostrar' : 'Ocultar'),
                              ),
                            ),
                            title: Text(formulario.titulo),
                            subtitle: Text(sub),
                            trailing: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RellenarFormPage(form: formulario)),
                                );
                              },
                              child: Text('Ver Formulario'),
                            ),
                          );
                        },
                      ),
                  ),
                ],
              ),
    );
  }
}
