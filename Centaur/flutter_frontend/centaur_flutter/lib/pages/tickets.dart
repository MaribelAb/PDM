import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/pages/form.dart';
import 'package:centaur_flutter/pages/modificarTicket.dart';
import 'package:flutter/material.dart';
//import 'tu_archivo.dart'; // Reemplaza "tu_archivo.dart" con el nombre de tu archivo que contiene la función getTickets

class ListaTicketsPage extends StatefulWidget {
  final String token;

  ListaTicketsPage({required this.token});
  @override
  _ListaTicketsPageState createState() => _ListaTicketsPageState();

  List<Ticket> getListaTickets() {
    return _ListaTicketsPageState.getLista();
  }
}

class _ListaTicketsPageState extends State<ListaTicketsPage> {
  static List<Ticket> _tickets = [];
  bool _isLoading = true;
  static List<Ticket> lleno = [];

  @override
  void initState() {
    super.initState();
    _loadTickets();

  }

  void coger(List<Ticket> lista){
    lleno = lista;

  }

  List<Ticket> recibir(List<Ticket> lista){
    return lista;
  }

  Future<void> _loadTickets() async {
    try {
      List<Ticket> tickets = await getTickets(widget.token);
      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    coger(_tickets);
    } catch (e) {
      print('Error al cargar los tickets: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  static List<Ticket> getLista(){
    //_loadTickets;
    List<Ticket> tickets = lleno;
    return tickets;
  }
    
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tickets'),
      ),
      body: 
        
      _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tickets.isEmpty
              ? Center(child: Text('No hay tickets disponibles'))
              
              : ListView.builder(
                  itemCount: _tickets.length,
                  itemBuilder: (context, index) {
                    Ticket ticket = _tickets[index];
                    return ListTile(
                      leading: ElevatedButton(
                        onPressed: () { 
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyForm()),
                          );
                         },
                        child: Text('Crear'),
                      ),
                      title: Text(ticket.titulo.toString()), // Suponiendo que "titulo" es un campo en tu clase Ticket
                      subtitle: Text(ticket.descripcion.toString()),
                      trailing: ElevatedButton(
                        onPressed: () { 
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ModifyTicketPage(ticket:ticket)),
                          );
                         },
                        child: Text('Ver Ticket'),
                      ), // Suponiendo que "descripcion" es un campo en tu clase Ticket
                      // Puedes mostrar más detalles del ticket aquí según tu modelo Ticket
                    );
                  },
                ),
    );
  }
}