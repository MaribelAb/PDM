import 'package:centaur_flutter/pages/create_form.dart';
import 'package:flutter/material.dart';
import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/navigation_service.dart';
import 'package:centaur_flutter/pages/form.dart';
import 'package:centaur_flutter/pages/tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const AdminHome());

class AdminHome extends StatefulWidget { 
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
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
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){
                    //return ClientHome();
                    //return AgentHome();
                    return CreateForm();
                  }
                ));
                    }, 
                    child: Text('Formularios')
                  ),

                ],
              ),
            ],
          ),
      ),
      
    );
    
  }
}