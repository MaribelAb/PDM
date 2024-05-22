

import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/pages/calendar.dart';
import 'package:centaur_flutter/pages/formList.dart';
import 'package:centaur_flutter/pages/listaTareas.dart';
import 'package:centaur_flutter/pages/logout_page.dart';
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
                  child: Center(
                      child: Text("you just have to build them and...")),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                  ),
                  child: Center(
                      child: Text("you just have to build them and...")),
                ),
              ),
            ],
          ),
        ],
      ),
      Container(//MIS TICKETS
        color: Colors.green,
        child: Center(child: Text("you just have to build them and...")),
        constraints: BoxConstraints.expand(),
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
      
      Container(//ESTADÍSTICAS
        color: Colors.green,
        child: Center(child: Text("put them in the _widgetOption list")),
        constraints: BoxConstraints.expand(),
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
