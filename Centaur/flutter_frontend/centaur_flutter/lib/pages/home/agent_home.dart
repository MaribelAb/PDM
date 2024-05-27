// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/calendar.dart';
import 'package:centaur_flutter/pages/listaTareas.dart';
import 'package:centaur_flutter/pages/logout_page.dart';
import 'package:centaur_flutter/pages/ticketList.dart';
//import 'package:centaur_flutter/navigation_service.dart';
//import 'package:centaur_flutter/pages/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:centaur_flutter/api/auth/auth_api.dart';
//import 'package:centaur_flutter/pages/tickets.dart';

class AgentHome extends StatefulWidget {
  const AgentHome({super.key});

  @override
  State<AgentHome> createState() => _AgentHomeState();
}

class _AgentHomeState extends State<AgentHome> {
//Text("Home of client ${user.username}"),
  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    
  

    return MaterialApp(
      title: '¡Bienvenido ${user.username}!',
      
      theme: ThemeData(
        primaryColor: Colors.amber,
      ),
      home: AgentHomePage(),
        //actions: []
   
        
    );
  }
}





class AgentHomePage extends StatefulWidget {
  @override
  _AgentHomePageState createState() => _AgentHomePageState();
}

class _AgentHomePageState extends State<AgentHomePage> {
  int selectedIndex = 0;
  var items = 4;
  late List<Ticket> tickets;
  late List<Widget> widgetOptions;
  bool misTickets = false;

  @override
  void initState() {
    super.initState();
    // Inicializa tickets aquí dentro de initState()
    //tickets = ListaTicketsPage(token: tokenBox).getListaTickets();

    widgetOptions = <Widget>[
    //TICKETS  
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
                child: TicketList(misTickets:false)
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
                child: TicketList(misTickets:true)
              )
            ),
          ),
          SizedBox(height:10),
          ElevatedButton(
            onPressed: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateForm()),
              );*/
            },  
            child: Text('Crear')
          ),
          SizedBox(height:10),
        ]
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
  }
  
  //BuildContext? contexto = NavigationService.navigatorKey.currentContext;
  

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> getwidgetList(){
    return this.widgetOptions;
  }

  @override
  Widget build(BuildContext context) {
    BuildContext getcontext(){
      return this.context;
    }
    User user = context.read<UserCubit>().state;
    List<Widget> widegtlist = getwidgetList();
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: <Widget>[
              // Image widget positioned at centerLeft
              Padding(
                padding: EdgeInsets.only(right: 8.0), // Adjust the padding as needed
                child: Image.asset(
                  'images/logo_claro.png', // Replace 'image.png' with your image asset // Adjust the width of the image as needed
                  height: 55, // Adjust the height of the image as needed
                ),
              ),
              // Expanded widget to make the text fill remaining space
              Expanded(
                child: Text(
                  '¡Bienvenido ${user.username}!',
                  textAlign: TextAlign.center, // Center-align the text
                  style: TextStyle(fontSize: 20), // Adjust the font size as needed
                ),
              ),
            ],
          )

    ),
      bottomNavigationBar: MediaQuery.of(context).size.width <= 640
      ? BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
         
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket), 
            label: 'Mis Tickets'
            
          ),
        
          BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda), 
            label: 'Mi Agenda'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout), 
            label: 'Cerrar Sesión'
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,  
      ): null,
      body: Row(
        children: [
          if(MediaQuery.of(context).size.width > 640)
          Container(
            child: NavigationRail(
              elevation: 5,
              labelType: NavigationRailLabelType.all,
              selectedLabelTextStyle: const TextStyle(
                color: Colors.blue
              ),
              unselectedLabelTextStyle: const TextStyle(
                color: Colors.amber
              ),
              onDestinationSelected: (selectedIndex){
                setState(() {
                  this.selectedIndex=selectedIndex;
                });
              },
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Inicio'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.article), 
                  label: Text('Mis tickets')
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard), 
                  label: Text('Agenda')
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.logout), 
                  label: Text('Cerrar Sesión')
                ),
              ], 
              selectedIndex: selectedIndex,
            )
          ),
          Expanded(
            child: widegtlist.elementAt(selectedIndex),
          ),
        ],
      ),
    );
  }
  
  
}



