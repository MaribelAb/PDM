import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/pages/index_page.dart';
import 'package:centaur_flutter/pages/login_agente.dart';
import 'package:centaur_flutter/pages/login_cliente.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [ElevatedButton].

void main() {
  runApp(const LogoutPage());
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
Widget build(BuildContext context) {
  const String appTitle = 'Centaur: cerrar sesion';
  return Center( // Center the content vertically and horizontally
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset("images/logo_claro.png"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("¿Quieres cerrar sesión?"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: EdgeInsets.only(top: 5, bottom: 5),
              ),
              child: Text(
                "Cerrar sesión",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                var ret = await logout();
                if (ret) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return IndexPage();
                    },
                  ));
                } else {
                  AlertDialog(
                    title: Text('Error'),
                    content: Text('No se ha podido cerrar sesión'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Aceptar'),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      );  
  }
}