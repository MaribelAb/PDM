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
import 'package:centaur_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'tu_archivo.dart'; // Reemplaza "tu_archivo.dart" con el nombre de tu archivo que contiene la función getTickets

class FormList extends StatefulWidget {
  final String s; // Use final for immutable properties

  FormList(this.s, {super.key});

  @override
  _FormListState createState() => _FormListState(s);
}

class _FormListState extends State<FormList> {
  List<Formulario> _formularios = [];
  bool _isLoading = true;
  String loc = '';

  _FormListState(this.loc); // Proper constructor initialization

  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadForms();
    loc = widget.s;
    print(loc);
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

    if (user.groups!.contains('Client')) {
      cliente = true;
    }

    List<Formulario> filteredFormularios = [];
    if (cliente) {
      filteredFormularios = _formularios.where((formulario) => !formulario.oculto).toList();
    }

    if(cliente){
      if (loc == 'Comunicacion') {
      filteredFormularios = filteredFormularios.where((formulario) => formulario.categoria == 'Comunicacion').toList();
    } else if (loc == 'Incidencias') {
      filteredFormularios = filteredFormularios.where((formulario) => formulario.categoria == 'Incidencias').toList();
    } else if (loc == 'Quejas') {
      filteredFormularios = filteredFormularios.where((formulario) => formulario.categoria == 'Quejas').toList();
    }
    _formularios = filteredFormularios;
    }

    

    return Scaffold(
      appBar: AppBar(),
      body: FocusableActionDetector(
        focusNode: FocusNode(),
        child: Column(
          children: [
            Center(child: Text('Formularios', style: tituloStyle(context))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                hintText: 'Introduce el término de búsqueda',
                controller: search,
                leading: IconButton(
                  iconSize: 24,
                  icon: Tooltip(child: Icon(Icons.search), message: 'Buscar formulario',),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FormSearch(clave: search.text)),
                    );
                  },
                ),
              ),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _formularios.isEmpty
                        ? Center(child: Text('No hay formularios disponibles'))
                        : ListView.builder(
                            itemCount: _formularios.length,
                            itemBuilder: (context, index) {
                              Formulario formulario = _formularios[index];
                              if (formulario.oculto) {
                                estado = 'Este formulario está oculto';
                              } else {
                                estado = 'Este formulario está visible';
                              }
        
                              sub = cliente ? formulario.descripcion : estado;
        
                              return ListTile(
                                leading: Visibility(
                                  visible: !cliente,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(24, 24), // Tamaño de 24x24 o más
                                    ),
                                    onPressed: () async {
                                      var resp = await editarVisibilidad(formulario);
                                      if (resp) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Correcto'),
                                              content: Text('Visibilidad cambiada de forma exitosa'),
                                              actions: [
                                                TextButton(
                                                  style: ElevatedButton.styleFrom(
                                                    minimumSize: Size(24, 24), // Tamaño de 24x24 o más
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    setState(() {});
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
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Text(formulario.oculto ? 'Mostrar' : 'Ocultar'),
                                  ),
                                ),
                                title: Text(formulario.titulo),
                                subtitle: Text(sub),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(24, 24), // Tamaño de 24x24 o más
                                  ),
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
      ),
    );
  }
}
