import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/home/admin_home.dart';
import 'package:centaur_flutter/pages/home/agent_home.dart';
//import 'package:centaur_flutter/pages/form.dart';
//import 'package:centaur_flutter/pages/home/home_agente.dart';
//import 'package:centaur_flutter/pages/home/home_cliente.dart';
import 'package:centaur_flutter/pages/registrations_agente.dart';
import 'package:flutter/material.dart';
import 'package:centaur_flutter/pages/registration_cliente.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:centaur_flutter/widgets/text_button.dart';
import 'package:centaur_flutter/widgets/field.dart';
import 'package:centaur_flutter/pages/forgot_pass.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:centaur_flutter/models/user_model.dart';

class SignInAgent extends StatefulWidget {
  const SignInAgent({Key? key}) : super(key: key);

  @override
  State<SignInAgent> createState() => _SignInAgentState();
}

class _SignInAgentState extends State<SignInAgent> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        children: [
          Container(
            height: 200,
            child: Image.asset('images/logo_claro.png'),
          ),
          SizedBox(height: 100),
          CustomField(
            controller: usernameController,
            iconUrl: 'assets/icon_email.png',
            hint: 'Nombre de usuario',
          ),
          CustomField(
            controller: passwordController,
            iconUrl: 'assets/icon_password.png',
            hint: 'Contraseña',
            obsecure: true,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPassPage()),
                );
              },
              child: Text(
                "¿Has olvidado la contraseña?",
                style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
              ),
            ),
          ),
          CustomTextButton(
            onTap: () async {
              var authRes = await userAuth(usernameController.text, passwordController.text);
              if (authRes.runtimeType == String) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Container(
                        alignment: Alignment.center,
                        height: 200,
                        width: 250,
                        decoration: const BoxDecoration(),
                        child: Text(authRes),
                      ),
                    );
                  },
                );
              } else if (authRes is User) {
                User user = authRes;
                if (user.groups!.contains('Client')) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          alignment: Alignment.center,
                          height: 200,
                          width: 250,
                          decoration: const BoxDecoration(),
                          child: Text('No tiene permiso para acceder'),
                        ),
                      );
                    },
                  );
                } else if(user.groups?.isEmpty == true){
                  context.read<UserCubit>().emit(user);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return AdminHome();
                    },
                  ));
                }
              else{
                  context.read<UserCubit>().emit(user);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return AgentHome();
                    },
                  ));
                }
              }
            },
            title: 'Inicia Sesión',
            margin: EdgeInsets.only(top: 50),
          ),
        ],
      ),
    );
  }
}
