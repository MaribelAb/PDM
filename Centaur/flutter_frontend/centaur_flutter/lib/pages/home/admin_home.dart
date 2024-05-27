

import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/pages/calendar.dart';
import 'package:centaur_flutter/pages/create_form.dart';
import 'package:centaur_flutter/pages/formList.dart';
import 'package:centaur_flutter/pages/listaTareas.dart';
import 'package:centaur_flutter/pages/logout_page.dart';
import 'package:centaur_flutter/pages/ticketList.dart';
import 'package:centaur_flutter/pages/view_bar_chart.dart';
import 'package:centaur_flutter/pages/view_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';



class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  List<String?>? _agentes = [];
  List<String?>? _clientes = [];
  List<User?>? _usuarios = [];
  bool _isLoading = true;
  List<Ticket> _tickets = [];
  bool misTickets = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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

  Future<void> _getAgentes() async {
    try {
      List<String?>? agentes = await getAgentUsers();
      setState(() {
        _agentes = agentes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los usuarios (codigo): $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getClientes() async {
    try {
      List<String?>? clientes = await getClientUsers();
      setState(() {
        _clientes = clientes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los usuarios (codigo): $e');
      setState(() {
        _isLoading = false;
      });
    }
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
  void initState() {
    super.initState();
    _getAgentes();
    _getClientes();
    _loadTickets();
    _getAllUsers();
  }



  @override
  Widget build(BuildContext context) {
    final List<NavigationRailDestination> destinations = [
      NavigationRailDestination(
        icon: Icon(Icons.dashboard),
        label: Text('Inicio'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.airplane_ticket),
        label: Text('Mis tickets'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.article),
        label: Text('Formularios'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.stacked_bar_chart),
        label: Text('Estadísticas'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.view_agenda),
        label: Text('Agenda'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.logout),
        label: Text('Cerrar sesión'),
      ),
    ];

    List<Widget> widgetOptions = <Widget>[
      Column(
        children: [
          Center(child: Text('Usuarios'),),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
              ),
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
            )
          ),
          
        ],
      ),
      
      //MIS TICKETS
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
              ),
              child: SizedBox(
                height: 200,
                child: TicketList(misTickets: true)
              )
            ),
          ),
          
        ]
      ),
      //FORMULARIOS
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
              ),
              child: SizedBox(
                height: 200,
                child: FormList()
              )
            ),
          ),
          SizedBox(height:10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateForm()),
              );
            },  
            child: Text('Crear')
          ),
          SizedBox(height:10),
        ]
    ),
      
      Column(//INICIO
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                  ),
                  child: SizedBox(
                    height: 200,
                    child:Row(
                      children: [
                        Center(
                          child:IconButton(
                            icon: Icon(Icons.arrow_left,),
                            onPressed: () { 
                              if (_pageController.page! > 0) {
                                _pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          )
                        ),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            children: [
                              ViewBarChart(),
                              ViewLineChart(),
                            ],
                          ),
                        ),
                        Center(
                          child:IconButton(
                            icon: Icon(Icons.arrow_right),
                            onPressed: () { 
                              if (_pageController.page! < 2) {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          )
                        ),
                      ]
                    )
                  )
                ),
              ),
              
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                  ),
                  child: Column(
                    children: [
                      Center(child: Text('Usuarios')),
                      Row(
                        children: [
                          Text('Número de agentes: '),
                          Text(_agentes!.length.toString())
                        ],
                      ),
                      Row(
                        children: [
                          Text('Número de clientes: '),
                          Text(_clientes!.length.toString())
                        ],
                      )
                    ],
                  )
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                  ),
                  child: Column(
                    children: [
                      Center(child: Text('Tickets')),
                      Row(
                        children: [
                          Text('Número de tickets creados: '),
                          Text(_tickets.length.toString())
                        ],
                      ),
                      Row(
                        children: [
                          Text('Número de tickets resueltos: '),
                          Text(_tickets.where((ticket) => ticket.estado == 'cerrado').length.toString())
                        ],
                      ),
                      Row(
                        children: [
                          Text('Número de tickets en curso: '),
                          Text(_tickets.where((ticket) => ticket.estado == 'en_curso').length.toString())
                        ],
                      ),
                      Row(
                        children: [
                          Text('Número de tickets abiertos: '),
                          Text(_tickets.where((ticket) => ticket.estado == 'abierto').length.toString())
                        ],
                      )
                    ],
                  )
                ),
              ),
            ],
          ),
        ],
      ),
      //AGENDA
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
              ),
              child: SizedBox(
                height: 200,
                child: ListaTareas()
              )
            ),
          ),
          SizedBox(height:10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Calendar()),
              );
            },  
            child: Text('Crear')
          ),
          SizedBox(height:10),
        ]
      ),
      //LOGOUT
      Expanded(
        child: Container(
          margin: EdgeInsets.all(1.0),
          
          decoration: BoxDecoration(
            border: Border.all(width: 1),
          ),
          child: LogoutPage()
          )
      ),
      
    ];

    User user = context.read<UserCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Image.asset(
                'images/logo_claro.png',
                height: 55,
              ),
            ),
            Expanded(
              child: Text(
                '¡Bienvenido ${user.username}!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      drawer: MediaQuery.of(context).size.width <= 640
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: destinations.map((destination) {
                  int index = destinations.indexOf(destination);
                  return ListTile(
                    leading: IconTheme(
                      data: IconThemeData(
                        color: _selectedIndex == index ? Colors.blue : Colors.amber,
                      ),
                      child: destination.icon,
                    ),
                    title: Text(
                      (destination.label as Text).data!,
                      style: TextStyle(
                        color: _selectedIndex == index ? Colors.blue : Colors.amber,
                      ),
                    ),
                    selected: _selectedIndex == index,
                    onTap: () {
                      _onItemTapped(index);
                      setState(() {
                        
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            )
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 640)
            Container(
              child: NavigationRail(
                    elevation: 5,
                    labelType: NavigationRailLabelType.all,
                    selectedLabelTextStyle: const TextStyle(color: Colors.blue),
                    unselectedLabelTextStyle: const TextStyle(color: Colors.amber),
                    onDestinationSelected: (selectedIndex) {
                      setState(() {
                        _selectedIndex = selectedIndex;
                      });
                    },
                    destinations: destinations,
                    selectedIndex: _selectedIndex,
                  ),
                
            ),
          Expanded(
            child: widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
