import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/formulario_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/rellenarForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormSearch extends StatefulWidget {
  final String clave;

  FormSearch({Key? key, required this.clave}) : super(key: key);

  @override
  FormSearchState createState() => FormSearchState();
}

class FormSearchState extends State<FormSearch> {
  List<Formulario> _formularios = [];
  List<Formulario> filteredForms = [];
  bool _isLoading = true;
  bool cliente = false;

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

  void _filterForms(bool cliente) {
    String busc = widget.clave.toLowerCase();
    if(cliente){
      filteredForms = _formularios.where((form) {
      return (form.titulo.toLowerCase().contains(busc) || form.descripcion.toLowerCase().contains(busc)) && form.oculto == false;
      }).toList();
    }
    else{
      filteredForms = _formularios.where((form) {
      return (form.titulo.toLowerCase().contains(busc) || form.descripcion.toLowerCase().contains(busc));
    }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    if(user.groups!.contains('Client')){
      cliente = true;
    }
    _filterForms(cliente);
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
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(24, 24), // Tamaño de 24x24 o más
                          ),
                          onPressed: () async {
                            var resp = await editarVisibilidad(formulario);
                            if (resp) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Correcto'),
                                  content: Text('Visibilidad cambiada de forma exitosa'),
                                  actions: [
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(24, 24), // Tamaño de 24x24 o más
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Aceptar'),
                                    ),
                                  ],
                                ),
                              );
                              setState(() {
                                _loadForms();
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text('No se ha podido cambiar la visibilidad'),
                                  actions: [
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(24, 24), // Tamaño de 24x24 o más
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Aceptar'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text(formulario.oculto ? 'Mostrar' : 'Ocultar'),
                        ),
                      ),
                      title: Text(formulario.titulo),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(24, 24), // Tamaño de 24x24 o más
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RellenarFormPage(form: formulario),
                            ),
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
