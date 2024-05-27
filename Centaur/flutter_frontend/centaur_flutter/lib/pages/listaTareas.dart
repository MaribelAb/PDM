import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/tarea_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/rellenarForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'tu_archivo.dart'; // Reemplaza "tu_archivo.dart" con el nombre de tu archivo que contiene la función getTickets

class ListaTareas extends StatefulWidget {
  @override
  _ListaTareasState createState() => _ListaTareasState();
}

class _ListaTareasState extends State<ListaTareas> {
  List<Tarea> _tareas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTareas();
  }

  Future<void> _loadTareas() async {
    try {
      User user = context.read<UserCubit>().state;
      List<Tarea> tareas = await obtenerTareas();
      setState(() {
        _tareas = tareas.where((tarea) => tarea.creador == user.username).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar las tareas: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tareas.isEmpty
              ? Column(
                children: [
                  Center(child: Text('No hay Tareas disponibles')),
                  
                ],
              )
              : ListView.builder(
                  itemCount: _tareas.length,
                  itemBuilder: (context, index) {
                    Tarea tarea = _tareas[index];
                    return ListTile(
                      leading: ElevatedButton(
                        onPressed: () {
                           
                        },
                        child: Text('Editar'),
                      ),
                      title: Text(tarea.titulo),
                      subtitle: Text(tarea.descripcion),
                      trailing: ElevatedButton(
                        onPressed: () {
                          
                        },
                        child: Text('Ver Tarea'),
                      ),
                    );
                  },
                ),
    );
  }
}
