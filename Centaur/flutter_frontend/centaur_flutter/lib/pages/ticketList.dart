import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/carpeta_model.dart';
import 'package:centaur_flutter/models/formulario_model.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/create_form.dart';
import 'package:centaur_flutter/pages/rellenarForm.dart';
import 'package:centaur_flutter/pages/ticketView.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TicketList extends StatefulWidget {
  final bool misTickets;
  TicketList({Key? key, required this.misTickets}) : super(key: key);

  @override
  _TicketListState createState() => _TicketListState(misTickets);
}


class _TicketListState extends State<TicketList> {
  List<Ticket> _tickets = [];
  List<Carpeta> folders = [];
  bool misTickets = false;
  bool _isLoading = true;
  String dropdownValue = 'Año natural';
  DateTime? fechaIni;
  DateTime? fechaFin;

  _TicketListState(this.misTickets);

  @override
  void initState() {
    super.initState();
    misTickets = widget.misTickets;
    // Initialize the date range with default values
    fechaIni = DateTime.now().subtract(Duration(days: 7));
    fechaFin = DateTime.now();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    try {
      List<Ticket> tickets = await getTickets();
      List<Ticket> filteredTickets = filterTicketsByDateRange(tickets);
      setState(() {
        _tickets = filteredTickets;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los tickets (codigo): $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Ticket> filterTicketsByDateRange(List<Ticket> tickets) {
    if (fechaIni != null && fechaFin != null) {
      return tickets.where((ticket) {
        return ticket.fecha_creacion != null &&
            ticket.fecha_creacion!.isAfter(fechaIni!) &&
            ticket.fecha_creacion!.isBefore(fechaFin!);
      }).toList();
    } else {
      return tickets;
    }
  }

  

  Map<String, List<Ticket>> _groupTickets(List<Ticket> tickets, String criteria) {
    Map<String, List<Ticket>> groupedTickets = {};

    for (var ticket in tickets) {
      String key;
      switch (criteria) {
        case 'Encargado':
          key = ticket.asignee.toString();
          break;
        case 'Año natural':
          key = ticket.fecha_creacion != null ? ticket.fecha_creacion!.year.toString() : 'N/A';
          break;
        case 'Fecha de creacion':
          key = ticket.fecha_creacion?.toString() ?? 'N/A';
          break;
        case 'Rango de fechas':
          key = ticket.fecha_creacion?.toString() ?? 'N/A';
          break;
        case 'Estado':
          key = ticket.estado ?? 'N/A';
          break;
        case 'Prioridad':
          key = ticket.prioridad ?? 'N/A';
          break;
        default:
          key = 'N/A';
      }

      if (!groupedTickets.containsKey(key)) {
        groupedTickets[key] = [];
      }
      groupedTickets[key]!.add(ticket);
    }

    return groupedTickets;
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    bool cliente = user.groups!.contains('Client');
    bool agente = user.groups!.contains('Agent');
    List<Ticket>? filtered = [];

    if(cliente){
      for (var tick in _tickets){
        if(tick.solicitante == user.username)
          filtered.add(tick);
      }
      _tickets = filtered;
    }
    if(agente && misTickets){
      for (var tick in _tickets){
        if(tick.asignee == user.username)
          filtered.add(tick);
      }
      _tickets = filtered;
    }

    Map<String, List<Ticket>> groupedTickets = _groupTickets(_tickets, dropdownValue);

    List<String> opciones = ['Año natural', 'Fecha de creacion', 'Rango de fechas',];
    if (cliente == false) {
      opciones.add('Estado');
      opciones.add('Encargado');
      opciones.add('Prioridad');
    }


    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _loadTickets(),
        child: FocusableActionDetector(
          focusNode: FocusNode(),
          child: Column(
            children: [
              Center(child: Text('Tickets', style: tituloStyle(context))),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _tickets.isEmpty
                      ? Column(
                          children: [
                            Center(child: Text('No hay tickets disponibles')),
                          ],
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Agrupar tickets por: '),
                                    DropdownButton(
                                      value: dropdownValue,
                                      icon: Tooltip(child: Icon(Icons.arrow_downward), message: 'Expandir la lista de opciones de agrupación'),
                                      elevation: 16,
                                      style: const TextStyle(color: Colors.blue),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.blue,
                                      ),
                                      items: opciones.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          dropdownValue = value!;
                                        });
                                      },
                                    ),
                                    if (dropdownValue == 'Rango de fechas')
                                      Column(
                                        children: [
                                          TextButton(
                                            style: ElevatedButton.styleFrom(
    minimumSize: Size(24, 24), // Tamaño de 24x24 o más
  ),
                                            onPressed: () async {
                                              final DateTime? pickedStart = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2015, 8),
                                                lastDate: DateTime.now(),
                                              );
                                              if (pickedStart != null && pickedStart != fechaIni) {
                                                
                                                setState(() {
                                                  fechaIni = pickedStart;
                                                  _loadTickets();
                                                });
                                              }
                                            },
                                            child: Text(
                                              fechaIni != null ? 'Desde: ${DateFormat('dd-MM-yyyy').format(fechaIni!)}' : 'Desde',
                                            ),
                                          ),
                                          TextButton(
                                            style: ElevatedButton.styleFrom(
    minimumSize: Size(24, 24), // Tamaño de 24x24 o más
  ),
                                            onPressed: () async {
                                              final DateTime? pickedEnd = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2015, 8),
                                                lastDate: DateTime.now(),
                                              );
                                              if (pickedEnd != null && pickedEnd != fechaFin) {
                                                setState(() {
                                                  fechaFin = pickedEnd;
                                                  _loadTickets();
                                                });
                                              }
                                            },
                                            child: Text(
                                              fechaFin != null ? 'Hasta: ${DateFormat('dd-MM-yyyy').format(fechaFin!)}' : 'Hasta',
                                            ),
                                          ),
                                          if (_tickets.isEmpty)
                                            Text(
                                              'No existen tickets en ese rango de fechas',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                        ],
                                      )
                                  ],
                                ),
                                SizedBox(height: 20),
                                ...groupedTickets.keys.map((key) {
                                  return Semantics(
                                    label: 'Expandir grupo de tickets agrupados por ${dropdownValue.toString()}',
                                    child: ExpansionTile(
                                      title: Text(key),
                                      children: groupedTickets[key]!.map((ticket) {
                                        String contenidoPreview = ticket.contenido != null
                                            ? ticket.contenido!.map((c) => c.valor).join(', ')
                                            : 'Sin contenido';
                                        return ListTile(
                                          title: Text(ticket.titulo ?? 'No Title'),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Solicitante: ${ticket.solicitante}'),
                                              Text(contenidoPreview, maxLines: 2, overflow: TextOverflow.ellipsis),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TicketViewPage(ticket: ticket),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
              
            ],
          ),
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
            style: ElevatedButton.styleFrom(
              minimumSize: Size(24.0, 24) // Tamaño de 24x24 o más
  ),
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