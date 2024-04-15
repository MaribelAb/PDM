import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:centaur_flutter/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
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
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: const SignInPage(),
      
      ),
    );
  }
}