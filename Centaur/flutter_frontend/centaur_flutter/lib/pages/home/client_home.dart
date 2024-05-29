import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/navigation_service.dart';
import 'package:centaur_flutter/pages/formList.dart';
import 'package:centaur_flutter/pages/inicioCli.dart';
import 'package:centaur_flutter/pages/logout_page.dart';
import 'package:centaur_flutter/pages/ticketList.dart';
//import 'package:centaur_flutter/navigation_service.dart';
//import 'package:centaur_flutter/pages/form.dart';
//import 'package:centaur_flutter/pages/tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
//Text("Home of client ${user.username}"),
  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    return MaterialApp(
      title: '¡Bienvenido ${user.username}!',
      
      theme: ThemeData(
        primaryColor: Colors.amber,
      ),
      home: MyHomePage(),
        //actions: []
   
        
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  bool misTickets=true;
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
                child: ClientIni()
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

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  

  @override
  Widget build(BuildContext context) {
  
  

    User user = context.read<UserCubit>().state;
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
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
         
          BottomNavigationBarItem(
            icon: Icon(Icons.article), 
            label: 'Formularios'
          ),
        
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), 
            label: 'Mis Tickets'
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
                  label: Text('Formularios')
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard), 
                  label: Text('Mis Tickets')
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.logout),
                  label: Text('Cerrar sesión'),
                ),
              ], 
              selectedIndex: selectedIndex,
            )
          ),
          Expanded(
            child: widgetOptions.elementAt(selectedIndex),
          ),
        ],
      ),
    );
  }
  
  
}



