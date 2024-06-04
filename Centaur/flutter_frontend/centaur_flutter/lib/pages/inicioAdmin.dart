import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:flutter/material.dart';

class AdminIni extends StatefulWidget {
  const AdminIni({super.key});

  @override
  State<AdminIni> createState() => _AdminIniState();
}

class _AdminIniState extends State<AdminIni>{
  List<User?>? _usuarios = [];
  bool _isLoading = true;
    Future<void> _getAllUsers() async {
    try {
      List<User?>? usuarios = await getAllUsers();
      setState(() {
        _usuarios = usuarios;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los usuarios (codigo): $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Center(child: Text('Usuarios', style: tituloStyle)),
          Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Nombre de usuario')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Grupo')),
                    DataColumn(label: Text('Acción'))
                  ], 
                  rows: _usuarios!.map((usuario){
                    return DataRow(
                      cells: [
                        DataCell(Text(usuario?.username ?? 'No Title')),
                        DataCell(Text(usuario?.email ?? 'N/A')),
                        DataCell(Text(usuario?.groups.toString() ?? 'N/A')),
                        DataCell(
                          ElevatedButton(
                          onPressed: (){

                          }, 
                          child: Text('Administrar')
                          )
                        )
                      ]
                    );
                  }).toList(),
                ),
              )
          ),
          
        ],
      );
  }

}



