import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/formList.dart';
import 'package:centaur_flutter/pages/ticketList.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientIni extends StatefulWidget {
  const ClientIni({super.key});

  @override
  State<ClientIni> createState() => _ClientIniState();
}

class _ClientIniState extends State<ClientIni>{
  List<Ticket> _tickets = [];
  bool _isLoading = true;
   
   
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

  List<Ticket> filteredTickets = []; 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTickets();
    
  }   
     

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    filteredTickets = _tickets.where((ticket) => ticket.estado == 'abierto' && ticket.solicitante == user.username).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio', style: tituloStyle),
        centerTitle: true,
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MediaQuery.of(context).size.width <= 640
          ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 20,),
              SizedBox(
                width: 200, // Same width as above
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text("Comunicación",style: defaultStyle),
                  
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return FormList('Comunicacion');
                      },
                    ));
                  },
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: 200, // Same width as above
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text("Incidencias", style: defaultStyle),
                  
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return FormList('Incidencias');
                      },
                    ));
                  },
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: 200, // Same width as above
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text("Quejas", style: defaultStyle,),
                  
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return FormList('Quejas');
                      },
                    ));
                  },
                ),
              ),
              
            ],
          )
          :Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 200, // Same width as above
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text("Comunicación", style: subtituloStyle),
                  
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return FormList('Comunicacion');
                      },
                    ));
                  },
                ),
              ),
              SizedBox(
                width: 200, // Same width as above
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text("Incidencias", style: subtituloStyle),
                  
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return FormList('Incidencias');
                      },
                    ));
                  },
                ),
              ),
              SizedBox(
                width: 200, // Same width as above
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text("Quejas", style: subtituloStyle),
                  
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return FormList('Quejas');
                      },
                    ));
                  },
                ),
              ),
              
            ],),
          SizedBox(height: 50,),
          Center(child: Text('Lista de tickets abiertos:'),),
          Expanded(
            child: Container(
              height: 200,
              margin: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
              ),
              child:SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(label: Text('Título')),
              DataColumn(label: Text('Solicitante')),
              DataColumn(label: Text('Responsable')),
              DataColumn(label: Text('Estado')),
            ],
            rows: filteredTickets.map((ticket) {
              List<DataCell> cells = [
                DataCell(Text(ticket.titulo ?? 'No Title')),
                DataCell(Text(ticket.solicitante ?? 'N/A')),
                DataCell(Text(ticket.asignee ?? 'N/A')),
                DataCell(Text(ticket.estado ?? 'N/A')),
              ];
              
              
              return DataRow(cells: cells);
            }).toList(),
          ),
        ),
      ),
              
            ),
          ),
          
            
        ]
      )
    );
  }
}