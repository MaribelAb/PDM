import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/calendar.dart';
import 'package:centaur_flutter/pages/home/admin_home.dart';
import 'package:centaur_flutter/pages/home/client_home.dart';
//import 'package:centaur_flutter/navigation_service.dart';
//import 'package:centaur_flutter/pages/form.dart';
//import 'package:centaur_flutter/pages/home/home_agente.dart';
//import 'package:centaur_flutter/pages/home/home_cliente.dart';
import 'package:centaur_flutter/pages/index_page.dart';
import 'package:centaur_flutter/pages/registration_cliente.dart';
import 'package:flutter/material.dart';
import 'package:centaur_flutter/pages/login_cliente.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:centaur_flutter/pages/themenot.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
//import 'package:centaur_flutter/pages/create_form.dart';
import 'package:flutter/semantics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initializeDateFormatting('es_ES', null);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    SemanticsBinding.instance.ensureSemantics();
    
    return BlocProvider(
      create: (context) { 
        return UserCubit(User());
       },
      child: MaterialApp(
        title: 'Centaur',
        //navigatorKey: NavigationService.navigatorKey, // set property
        theme: themeNotifier.currentTheme,
        home: IndexPage()
        /*MediaQuery.of(context).size.width <= 640
        ? IndexPage()
        : AdminHome() */
        //home: AdminHome()
        //home: Calendar(),
      ),
    );
  }
}