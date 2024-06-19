

import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/pages/calendar.dart';
import 'package:centaur_flutter/pages/configuracion.dart';
import 'package:centaur_flutter/pages/create_form.dart';
import 'package:centaur_flutter/pages/formList.dart';
import 'package:centaur_flutter/pages/inicioAdmin.dart';
import 'package:centaur_flutter/pages/listaTareas.dart';
import 'package:centaur_flutter/pages/logout_page.dart';
import 'package:centaur_flutter/pages/themenot.dart';
import 'package:centaur_flutter/pages/ticketList.dart';
import 'package:centaur_flutter/pages/view_bar_chart.dart';
import 'package:centaur_flutter/pages/view_line_chart.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';



class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
   PageController _navController = PageController();
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
    _navController.dispose();
    super.dispose();
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

  }

  

  @override
  Widget build(BuildContext context) {
        final themeNotifier = Provider.of<ThemeNotifier>(context);
    final List<NavigationRailDestination> destinations = [
      NavigationRailDestination(
        icon: Tooltip(child: Icon(Icons.dashboard),message: 'Navegar a Inicio',),
        label: Text('Inicio'),
      ),
      NavigationRailDestination(
        icon: Tooltip(child: Icon(Icons.airplane_ticket),message: 'Navegar a mis tickets',),
        label: Text('Mis tickets'),
      ),
      NavigationRailDestination(
        icon: Tooltip(child: Icon(Icons.article),message: 'Navegar a Formularios',),
        label: Text('Formularios'),
      ),
      NavigationRailDestination(
        icon: Tooltip(child: Icon(Icons.stacked_bar_chart),message: 'Navegar a estadísticas',),
        label: Text('Estadísticas'),
      ),
      NavigationRailDestination(
        icon: Tooltip(child: Icon(Icons.view_agenda),message: 'Navegar a Agenda',),
        label: Text('Agenda'),
      ),
      NavigationRailDestination(
        icon: Tooltip(child: Icon(Icons.settings),message: 'Navegar a configuración',), 
        label: Text('Configuración')
      ),
    ];

    List<Widget> widgetOptions = <Widget>[
      //INICIO
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
                child: AdminIni()
              )
            ),
          ),
          
        ]
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
                child: FormList('')
              )
            ),
          ),
          SizedBox(height:10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(24, 24), 
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateForm()),
              );
            },  
            child: Text('Crear', style: normalStyle(context),)
          ),
          SizedBox(height:10),
        ]
    ),
      //ESTADÍSTICAS
      FocusableActionDetector(
        focusNode: FocusNode(),
        child: Column(
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
                              icon: Tooltip(child: Icon(Icons.arrow_left,),message: 'Gráfica anterior',),
                              iconSize: 24,
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
                              iconSize: 24,
                              icon: Tooltip(child: Icon(Icons.arrow_right),message: 'Siguiente gráfica',),
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
                        Center(child: Text('Tickets',)),
                        Row(
                          children: [
                            Text('Número de tickets creados: ',),
                            Text(_tickets.length.toString(),)
                          ],
                        ),
                        Row(
                          children: [
                            Text('Número de tickets resueltos: ',),
                            Text(_tickets.where((ticket) => ticket.estado == 'cerrado').length.toString(),)
                          ],
                        ),
                        Row(
                          children: [
                            Text('Número de tickets en curso: ',),
                            Text(_tickets.where((ticket) => ticket.estado == 'en_curso').length.toString(),)
                          ],
                        ),
                        Row(
                          children: [
                            Text('Número de tickets abiertos: ',),
                            Text(_tickets.where((ticket) => ticket.estado == 'abierto').length.toString(),)
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
            style: ElevatedButton.styleFrom(
              minimumSize: Size(24, 24),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Calendar()),
              );
            },  
            child: Text('Crear Tarea',style: normalStyle(context))
          ),
          SizedBox(height:10),
        ]
      ),
      //Configuración
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
                child: Configuracion()
              )
            ),
          ),
          
        ]
      ),
      
    ];

    User user = context.read<UserCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              
              child: themeNotifier.isDarkTheme ? Image.asset('assets/images/logo_oscuro.png', height: 55,) 
              : Image.asset('assets/images/logo_claro.png',height: 55,),
              
              
            ),
            Expanded(
              child: Text(
                '¡Bienvenido ${user.username}!',
                textAlign: TextAlign.center,
                style: greetingStyle(context),
              ),
            ),
          ],
        ),
      ),
      drawer: MediaQuery.of(context).size.width <= 640
          ? Drawer(
              semanticLabel: 'Menú de navegación desplegable',
              child: ListView(
                padding: EdgeInsets.zero,
                children: destinations.map((destination) {
                  int index = destinations.indexOf(destination);
                  return ListTile(
                    leading: IconTheme(
                      data: IconThemeData(
                        color: _selectedIndex == index ? Colors.blue : Color.fromARGB(255, 202, 153, 5),
                      ),
                      child: destination.icon,
                    ),
                    title: Text(
                      (destination.label as Text).data!,
                      style: TextStyle(
                        color: _selectedIndex == index ? Colors.blue : Color.fromARGB(255, 202, 153, 5),
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
                //backgroundColor: Colors.amber,
                    elevation: 5,
                    labelType: NavigationRailLabelType.all,
                    selectedLabelTextStyle: TextStyle(color: Colors.blue),
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
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}