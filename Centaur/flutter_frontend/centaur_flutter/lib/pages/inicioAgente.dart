import 'package:centaur_flutter/models/carpeta_model.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/ticketView.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart'; // Make sure you have this package in your pubspec.yaml
import 'package:centaur_flutter/pages/themenot.dart';
import 'package:centaur_flutter/api/auth/auth_api.dart'; // Import your logout function7
import 'package:draggable_scrollbar/draggable_scrollbar.dart';


class AgentIni extends StatefulWidget {
  bool misTickets;
  AgentIni({Key? key, required this.misTickets}) : super(key: key);

  @override
  _AgentIniState createState() => _AgentIniState(misTickets);
}

class _AgentIniState extends State<AgentIni> {
  List<Ticket> _tickets = [];
  bool misTickets = false;
  bool _isLoading = true;

  _AgentIniState(this.misTickets);

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
    User user = context.read<UserCubit>().state;
    bool cliente = user.groups!.contains('Client');
    bool agente = user.groups!.contains('Agent');

    List<Ticket> filteredTickets = [];
    if (cliente) {
      filteredTickets = _tickets.where((ticket) => ticket.solicitante == user.username).toList();
      _tickets = filteredTickets;
    }
    if (misTickets && agente) {
      filteredTickets = _tickets.where((ticket) => ticket.asignee == user.username).toList();
      _tickets = filteredTickets;
    }

    bool isSmallScreen = MediaQuery.of(context).size.width <= 640;

    return Scaffold(
      body: FocusableActionDetector(
        focusNode: FocusNode(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tickets',
                style: tituloStyle(context),
              ),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _tickets.isEmpty
                    ? Center(child: Text('No hay tickets disponibles'))
                    : Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columns: _buildColumns(cliente, isSmallScreen),
                            rows: _buildRows(cliente, isSmallScreen),
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(bool cliente, bool isSmallScreen) {
    List<DataColumn> columns = [
      DataColumn(label: Text('Título')),
      DataColumn(label: Text('Solicitante')),
    ];
    if (!cliente) {
      columns.add(DataColumn(label: Text('Prioridad')));
    }
    if (!isSmallScreen) {
      columns.addAll([
        DataColumn(label: Text('Responsable')),
        DataColumn(label: Text('Estado')),
        DataColumn(label: Text('Acciones')),
      ]);
    }
    return columns;
  }

  List<DataRow> _buildRows(bool cliente, bool isSmallScreen) {
    return _tickets.map((ticket) {
      List<DataCell> cells = [
        DataCell(
          Text(ticket.titulo ?? 'No Title', style: TextStyle(color: Colors.blue)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TicketViewPage(ticket: ticket),
              ),
            );
          },
        ),
        DataCell(Text(ticket.solicitante ?? 'N/A')),
      ];
      if (!cliente) {
        cells.add(DataCell(Text(ticket.prioridad ?? 'N/A')));
      }
      if (!isSmallScreen) {
        cells.addAll([
          DataCell(Text(ticket.asignee ?? 'N/A')),
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
      }
      return DataRow(cells: cells);
    }).toList();
  }
}
