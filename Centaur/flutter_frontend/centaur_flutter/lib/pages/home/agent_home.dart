// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/calendar.dart';
import 'package:centaur_flutter/pages/configuracion.dart';
import 'package:centaur_flutter/pages/inicioAgente.dart';
import 'package:centaur_flutter/pages/listaTareas.dart';
import 'package:centaur_flutter/pages/logout_page.dart';
import 'package:centaur_flutter/pages/themenot.dart';
import 'package:centaur_flutter/pages/ticketList.dart';
import 'package:centaur_flutter/theme.dart';
//import 'package:centaur_flutter/navigation_service.dart';
//import 'package:centaur_flutter/pages/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:provider/provider.dart';
//import 'package:centaur_flutter/pages/tickets.dart';

class AgentHome extends StatefulWidget {
  const AgentHome({super.key});

  @override
  State<AgentHome> createState() => _AgentHomeState();
}


class _AgentHomeState extends State<AgentHome> {
  int selectedIndex = 0;
  late List<Widget> widgetOptions;
  bool misTickets = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widgetOptions = <Widget>[
      //INICIO
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
      child: Center( 
        child: Container(
          margin: EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
          ),
          child: AgentIni(misTickets: false),
        ),
      ),
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
                child: TicketList(misTickets: true),
              ),
            ),
          ),
          SizedBox(height: 10),
          
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
                child: ListaTareas(),
              ),
            ),
          ),
          SizedBox(height: 10),
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
            child: Text('Crear Tarea'),
          ),
          SizedBox(height: 10),
        ],
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
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: themeNotifier.isDarkTheme
                  ? Image.asset('assets/images/logo_oscuro.png', height: 55,)
                  : Image.asset('assets/images/logo_claro.png', height: 55,),
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
      bottomNavigationBar: MediaQuery.of(context).size.width <= 640
          ? BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.airplane_ticket),
                  label: 'Mis Tickets',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_agenda),
                  label: 'Mi Agenda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Configuracion',
                ),
              ],
              currentIndex: selectedIndex,
              selectedItemColor: Colors.amber,
              unselectedItemColor: Colors.blue,
              onTap: _onItemTapped,
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
                    this.selectedIndex = selectedIndex;
                  });
                },
                destinations: const <NavigationRailDestination>[
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Inicio'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.article),
                    label: Text('Mis tickets'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.dashboard),
                    label: Text('Agenda'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Configuracion'),
                  ),
                ],
                selectedIndex: selectedIndex,
              ),
            ),
          Expanded(
            child: widgetOptions.elementAt(selectedIndex),
          ),
        ],
      ),
    );
  }
}
