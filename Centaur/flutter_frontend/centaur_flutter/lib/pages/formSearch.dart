import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/formulario_model.dart';
import 'package:centaur_flutter/pages/rellenarForm.dart';
import 'package:flutter/material.dart';

class FormSearch extends StatefulWidget {
  String clave;
  FormSearch({Key? key, required this.clave}) : super(key: key);

  @override
  FormSearchState createState() => FormSearchState(clave);
}



class FormSearchState extends State<FormSearch> {
  List<Formulario> _formularios = [];
  String busc = '';
  bool _isLoading = true;
  List<Formulario> filteredForms =[];
  String estado = '';
 
  
  FormSearchState(busc);

  @override
  void initState() {
    super.initState();
    _loadForms();
    busc = widget.clave;
    filteredForms = _formularios.where((form) => (form.titulo.contains(busc.toString()) == true || form.descripcion.contains(busc) == true) && form.oculto == true).toList();
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
     bool cliente = true;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Formularios'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredForms.isEmpty
              ? Column(
                children: [
                  Center(child: Text('No hay formularios disponibles')),
                  
                ],
              )
              : ListView.builder(
                  itemCount: filteredForms.length,
                  itemBuilder: (context, index) {
                    Formulario formulario = filteredForms[index];
                   
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
    );
  }
}