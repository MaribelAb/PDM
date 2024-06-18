import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/configuracion.dart';

import 'package:centaur_flutter/pages/formList.dart';
import 'package:centaur_flutter/pages/inicioCli.dart';
import 'package:centaur_flutter/pages/logout_page.dart';
import 'package:centaur_flutter/pages/themenot.dart';
import 'package:centaur_flutter/pages/ticketList.dart';
import 'package:centaur_flutter/theme.dart';
//import 'package:centaur_flutter/navigation_service.dart';
//import 'package:centaur_flutter/pages/form.dart';
//import 'package:centaur_flutter/pages/tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  int selectedIndex = 0;
  bool misTickets = true;

  List<Widget> widgetOptions = <Widget>[
    // INICIO
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
              child: ClientIni(),
            ),
          ),
        ),
      ],
    ),
    // FORMULARIOS
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
              child: FormList(''),
            ),
          ),
        ),
      ],
    ),
    // MIS TICKETS
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
      ],
    ),
    // CONFIGURACIÓN
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
              child: Configuracion(),
            ),
          ),
        ),
      ],
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    User user = context.read<UserCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: themeNotifier.isDarkTheme
                  ? Image.asset('assets/images/logo_oscuro.png', height: 55)
                  : Image.asset('assets/images/logo_claro.png', height: 55),
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
                  icon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: 'Formularios',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Mis Tickets',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Configuración',
                ),
              ],
              currentIndex: selectedIndex,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.amber,
              onTap: _onItemTapped,
            )
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 640)
            Column(
              children: [
                Expanded(
                  child: NavigationRail(
                    elevation: 5,
                    labelType: NavigationRailLabelType.all,
                    selectedLabelTextStyle: const TextStyle(color: Colors.blue),
                    unselectedLabelTextStyle: const TextStyle(color: Colors.amber),
                    onDestinationSelected: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    destinations: const <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Inicio'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.article),
                        label: Text('Formularios'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.dashboard),
                        label: Text('Mis Tickets'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text('Configuración'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                  ),
                ),
              ],
            ),
          Expanded(
            child: widgetOptions.elementAt(selectedIndex),
          ),
        ],
      ),
    );
  }
}
