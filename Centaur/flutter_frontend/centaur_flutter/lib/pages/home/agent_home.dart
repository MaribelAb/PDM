// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
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

  @override
  void initState() {
    super.initState();
    // Inicializa tickets aquí dentro de initState()
    //tickets = ListaTicketsPage(token: tokenBox).getListaTickets();

    widgetOptions = <Widget>[
    Container(
      color: Colors.green,
      child: Center(child: Text("you just have to build them and...")),
      constraints: BoxConstraints.expand(),
    ),
    Container(
      color: Colors.green,
      child: Center(child: Text("you just have to build them and...")),
      constraints: BoxConstraints.expand(),
    ),
    Container(
      color: Colors.green,
      child: Center(child: Text("put them in the _widgetOption list")),
      constraints: BoxConstraints.expand(),
    )
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
            label: 'Dashboard',
          ),
         
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket), 
            label: 'Mis Tickets'
            
          ),
        
          BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda), 
            label: 'Mi Agenda'
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
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.article), 
                  label: Text('Formularios')
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard), 
                  label: Text('Dashboard')
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



