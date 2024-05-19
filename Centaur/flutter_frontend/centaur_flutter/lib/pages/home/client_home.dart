import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
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
  List<Widget> widgetOptions = <Widget>[
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber,padding: EdgeInsets.only(top: 5,bottom: 5)),
              child: Text("Comunicación",style: TextStyle(color: Colors.black),),
              onPressed: () {
                /*BuildContext? context = NavigationService.navigatorKey.currentContext;
                Navigator.of(context!).push(MaterialPageRoute(
                  builder: (context){
                    return ListaTicketsPage(token: tokenBox,);
                  }
                )); */
              }
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber,padding: EdgeInsets.only(top: 5,bottom: 5)),
              child: Text("Incidencias",style: TextStyle(color: Colors.black),),
              onPressed: () {}
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber,padding: EdgeInsets.only(top: 5,bottom: 5)),
              child: Text("Quejas",style: TextStyle(color: Colors.black),),
              onPressed: () {}
            ),
            
          ],
        ),
        SearchBar(

        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container( 
                margin: EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  )
                ),
                child: Center(child: Text("you just have to build them and...")),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(1.0), 
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  )
                ),
                child: Center(child: Text("you just have to build them and...")),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  )
                ),
                child: Center(child: Text("you just have to build them and...")),
              ),
            ),
          ],
        )
      ]
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
            label: 'Home',
          ),
         
          BottomNavigationBarItem(
            icon: Icon(Icons.article), 
            label: 'Formularios'
          ),
        
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), 
            label: 'Dashboard'
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
            child: widgetOptions.elementAt(selectedIndex),
          ),
        ],
      ),
    );
  }
  
  
}



