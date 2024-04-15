import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home of ${user.username}"),
        //actions: []
        ),
    );
  }
}