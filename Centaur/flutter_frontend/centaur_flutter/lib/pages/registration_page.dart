import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:centaur_flutter/pages/login_page.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:centaur_flutter/widgets/text_button.dart';
import 'package:centaur_flutter/widgets/field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswdController = TextEditingController();
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
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
            hint: 'Username',
            controller: usernameController,
          ),
          CustomField(
            iconUrl: 'assets/icon_email.png',
            hint: 'Email',
            controller: emailController,
          ),
          CustomField(
            iconUrl: 'assets/icon_password.png',
            hint: 'Password',
            controller: passwordController,
            obsecure: true,
          ),
          CustomField(
            iconUrl: 'assets/icon_password.png',
            hint: 'Confirm Password',
            controller: confirmPasswdController,
            obsecure: true,
          ),
          CustomTextButton(
            title: 'Register',
            margin: EdgeInsets.only(top: 50),
            onTap: () async {
              var authRes = await registerUser(
                usernameController.text,
                emailController.text,
                passwordController.text,
                confirmPasswdController.text
              );

              if(authRes.runtimeType == String){
                // ignore: use_build_context_synchronously
                showDialog(
                  context: context, 
                  builder: (context){
                    return Dialog(
                      child: Container(
                        alignment: Alignment.center,
                        height: 200,
                        width: 250,
                        decoration: const BoxDecoration(),
                        child: Text(authRes)),
                    );
                  }
                );
              }
              else if(authRes.runtimeType == User){
                User user = authRes;
                context.read<UserCubit>().emit(user);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){
                    return Home();
                  }
                ));  // 
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
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: Text(
                    "Have an account? Log in",
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