import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/navigation_service.dart';
import 'package:centaur_flutter/pages/form.dart';
import 'package:centaur_flutter/pages/home/home_agente.dart';
import 'package:centaur_flutter/pages/home/home_cliente.dart';
import 'package:centaur_flutter/pages/index_page.dart';
import 'package:centaur_flutter/pages/registration_cliente.dart';
import 'package:flutter/material.dart';
import 'package:centaur_flutter/pages/login_cliente.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();

  runApp(
    const MyApp(),
    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) { 
        return UserCubit(User());
       },
      child: MaterialApp(
        title: 'Centaur',
        navigatorKey: NavigationService.navigatorKey, // set property
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        //home: const IndexPage(),
        home: const AgentHome(),
      
      ),
    );
  }
}