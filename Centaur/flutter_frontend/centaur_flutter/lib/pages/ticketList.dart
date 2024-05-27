import 'package:centaur_flutter/api/auth/auth_api.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'tu_archivo.dart'; // Reemplaza "tu_archivo.dart" con el nombre de tu archivo que contiene la función getTickets

class TicketList extends StatefulWidget {
  bool misTickets;
  TicketList({Key? key, required this.misTickets}) : super(key: key);

  @override
  _TicketListState createState() => _TicketListState(misTickets);
}



class _TicketListState extends State<TicketList> {
  List<Ticket> _tickets = [];
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
    
    
    
      
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tickets'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tickets.isEmpty
              ? Column(
                children: [
                  Center(child: Text('No hay tickets disponibles')),
                  
                ],
              )
              : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: _buildColumns(cliente),
            rows: _buildRows(cliente),
          )
            /*columns: [
              DataColumn(label: Text('Título')),
              DataColumn(label: Text('Solicitante')),
              DataColumn(label: Text('Responsable')),
              DataColumn(label: Text('Prioridad')),
              DataColumn(label: Text('Estado')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: _tickets.map((ticket) {
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
            }).toList(),
          ),*/
        ),
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
