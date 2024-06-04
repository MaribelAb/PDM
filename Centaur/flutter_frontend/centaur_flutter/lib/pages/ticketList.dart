import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/carpeta_model.dart';
import 'package:centaur_flutter/models/formulario_model.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/create_form.dart';
/*import 'package:centaur_flutter/pages/create_form.dart';
import 'package:centaur_flutter/pages/form.dart';
import 'package:centaur_flutter/pages/modificarTicket.dart';*/
import 'package:centaur_flutter/pages/rellenarForm.dart';
import 'package:centaur_flutter/pages/ticketView.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ticket_folder_page.dart';
//import 'tu_archivo.dart'; // Reemplaza "tu_archivo.dart" con el nombre de tu archivo que contiene la función getTickets

class TicketList extends StatefulWidget {
  bool misTickets;
  TicketList({Key? key, required this.misTickets}) : super(key: key);

  @override
  _TicketListState createState() => _TicketListState(misTickets);
}



class _TicketListState extends State<TicketList> {
  List<Ticket> _tickets = [];
  List<Carpeta> folders = [];
  bool misTickets = false;
  bool _isLoading = true;
  
  _TicketListState(misTickets);
  

  @override
  void initState() {
    super.initState();
    _loadTickets();
    misTickets = widget.misTickets;
  }

  Future<void> _loadTickets() async {
    try {
      List<Ticket> tickets = await getTickets();
      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los tickets (codigo): $e');
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
    bool agente = false;
    if (user.groups!.contains('Client')){
      cliente = true;
    }
    if (user.groups!.contains('Agent')){
      agente = true;
    }
    List<Ticket> filteredTickets =[];
    if(cliente == true ){
      filteredTickets = _tickets.where((ticket) => ticket.solicitante == user.username).toList();
      _tickets = filteredTickets;
    } 
if (misTickets == true && agente == true){
      filteredTickets = _tickets.where((ticket) => ticket.asignee == user.username).toList();
      _tickets = filteredTickets;
    }

    /*_tickets.forEach((tick) {
      Carpeta? existingFolder = folders.firstWhere(
        (carp) => carp.nombre == tick.carpeta,
        orElse: () => null,
      );
      if (existingFolder == null) {
      // If folder does not exist, create a new one and add the ticket
      Carpeta newFolder = Carpeta(nombre: '', tickets: []);
      newFolder.nombre = tick.carpeta!;
      newFolder.tickets = [tick];
      folders.add(newFolder);
    } else {
      // If folder exists, add the ticket to it
      existingFolder.tickets?.add(tick);
    }

      
    });*/
    
    List<String> opciones = ['Fecha de creacion', 'Estado', 'Prioridad'];
    String dropdownValue = opciones.first;
      
    return Scaffold(
      
      body: Column(
        children: [
          Center(child:Text('Tickets', style: tituloStyle)),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _tickets.isEmpty
                  ? Column(
                    children: [
                      Center(child: Text('No hay tickets disponibles')),
                      
                    ],
                  )
                  : Column(
                    children: [
                      Row(
                        children: [
                          Text('Agrupar tickets por: '),
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
                            items: opciones.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          ElevatedButton(
                            onPressed: (){
          
                            }, 
                            child: Text('Agrupar'))
                        ],
                      ),
                      SizedBox(height: 20,),
                      _isLoading ? Center(child: CircularProgressIndicator())
                      : folders.isEmpty ? Center(child: Text('No hay tickets disponibles'))
                      : ListView.builder(
                        itemCount: folders.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(folders[index].nombre.toString()),
                            onTap: () {
                              // Navigate to a new page to show tickets inside the folder
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TicketFolderPage(folder: folders[index],),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                child: DataTable(
                                  columns: _buildColumns(cliente),
                                  rows: _buildRows(cliente),
                                )
                                  
                              ),
                            ),
                    ],
                  ),
        ],
      ),
              
             
    );
  }
  List<DataColumn> _buildColumns(bool cliente) {
    List<DataColumn> columns = [
      DataColumn(label: Text('Título')),
      DataColumn(label: Text('Solicitante')),
      DataColumn(label: Text('Responsable')),
    ];
    if (!cliente) {
      columns.add(DataColumn(label: Text('Prioridad')));
    }
    columns.addAll([
      DataColumn(label: Text('Estado')),
      DataColumn(label: Text('Acciones')),
    ]);
    return columns;
  }
  List<DataRow> _buildRows(bool cliente) {
    return _tickets.map((ticket) {
      List<DataCell> cells = [
        DataCell(Text(ticket.titulo ?? 'No Title')),
        DataCell(Text(ticket.solicitante ?? 'N/A')),
        DataCell(Text(ticket.asignee ?? 'N/A')),
      ];
      if (!cliente) {
        cells.add(DataCell(Text(ticket.prioridad ?? 'N/A')));
      }
      cells.addAll([
        DataCell(Text(ticket.estado ?? 'N/A')),
        DataCell(
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketViewPage(ticket: ticket),
                ),
              );
            },
            child: Text('Ver Ticket'),
          ),
        ),
      ]);
      return DataRow(cells: cells);
    }).toList();
  }

}
