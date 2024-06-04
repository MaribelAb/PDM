import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/home/agent_home.dart';
//import 'package:centaur_flutter/pages/home/home_cliente.dart';
import 'package:flutter/material.dart';
import 'package:centaur_flutter/pages/login_cliente.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:centaur_flutter/widgets/text_button.dart';
import 'package:centaur_flutter/widgets/field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpAgent extends StatefulWidget {
  const SignUpAgent({Key? key}) : super(key: key);

  @override
  State<SignUpAgent> createState() => _SignUpAgentState();
}

class _SignUpAgentState extends State<SignUpAgent> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswdController = TextEditingController();
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Registro Agentes', style: tituloStyle,),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        children: [
          Container(
            margin: EdgeInsets.only(top: 100),
            child: Text(
              "Bienvenido a Centaur!",
              style: whiteTextStyle.copyWith(
                fontSize: 20,
                fontWeight: semiBold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          CustomField(
            iconUrl: 'assets/icon_name.png',
            hint: 'Nombre de usuario',
            controller: usernameController,
          ),
          CustomField(
            iconUrl: 'assets/icon_email.png',
            hint: 'Email',
            controller: emailController,
          ),
          CustomField(
            iconUrl: 'assets/icon_password.png',
            hint: 'Contraseña',
            controller: passwordController,
            obsecure: true,
          ),
          CustomField(
            iconUrl: 'assets/icon_password.png',
            hint: 'Confirma contraseña',
            controller: confirmPasswdController,
            obsecure: true,
          ),
          CustomTextButton(
            title: 'Regístrate',
            margin: EdgeInsets.only(top: 50),
            onTap: () async {
              List<dynamic> authRes = await registerUser(
                usernameController.text,
                emailController.text,
                passwordController.text,
                confirmPasswdController.text,
              );

              if (authRes[0] == null) {
                // Registration failed, display error message
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Container(
                        alignment: Alignment.center,
                        height: 200,
                        width: 250,
                        decoration: BoxDecoration(),
                        child: Text(authRes[1]),
                      ),
                    );
                  },
                );
              } else {
                // Registration successful
                if (authRes[0] is User) {
                  User user = authRes[0] as User;
                  List<String> groupnames = ['Agent'];
                  user.groups = groupnames;
                  context.read<UserCubit>().emit(user);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return AgentHome();
                    },
                  ));
                }
              }
            },
          ),
          Container(
            margin: EdgeInsets.only(
              top: 40,
              bottom: 74,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInClient()),
                    );
                  },
                  child: Text(
                    "¿Ya tienes cuenta? Inicia sesión",
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}