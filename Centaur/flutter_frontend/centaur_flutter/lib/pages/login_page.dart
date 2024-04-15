import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/user_cubit.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:centaur_flutter/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:centaur_flutter/pages/registration_page.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:centaur_flutter/widgets/text_button.dart';
import 'package:centaur_flutter/widgets/field.dart';
import 'package:centaur_flutter/pages/forgot_pass.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:centaur_flutter/models/user_model.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();


  @override
void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        children: [
          //Container(
          //  margin: EdgeInsets.only(top: 50),
          //  child: Image.asset(
          //    'assets/img_login.png',
          //  ),
         // ),
          SizedBox(
            height: 155,
          ),
          CustomField(
            controller: usernameController,
            iconUrl: 'assets/icon_email.png',
            hint: 'Username',
          ),
          CustomField(
            controller: passwordController,
            iconUrl: 'assets/icon_password.png',
            hint: 'Password',
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPassPage()),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
              ),
            ),
          ),
          CustomTextButton(
            onTap: () async {
              var authRes = await userAuth(usernameController.text, passwordController.text);
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
              //
            },
            title: 'Login',
            margin: EdgeInsets.only(top: 50),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 30,
              bottom: 74,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Register",
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