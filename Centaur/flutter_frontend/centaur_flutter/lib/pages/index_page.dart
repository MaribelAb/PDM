import 'package:centaur_flutter/pages/login_agente.dart';
import 'package:centaur_flutter/pages/login_cliente.dart';
import 'package:centaur_flutter/pages/themenot.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(const IndexPage());
}

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    const String appTitle = 'Centaur';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: 
        Column(
          
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Semantics(
                  label: 'Logo de Centaur. Consiste en un hombre con cuerpo de caballo blandiendo un arco, en un gradiente amarillo y naranja. Debajo está escrito Centaur',
                  child: themeNotifier.isDarkTheme ? Image.asset('assets/images/logo_oscuro.png') : Image.asset('assets/images/logo_claro.png')

                ),
              )
              ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Semantics(
                
                child: FocusableActionDetector(
                  focusNode: FocusNode(),
                  child: Text("Tipo de usuario", style: tituloStyle(context),)),
                header: true,
              )
            ),
            MediaQuery.of(context).size.width > 640
            ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                SizedBox(
                  width: 200, 
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: Size(24, 24),
                      padding: EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Semantics(
                      label: 'Ir a inicio de sesión clientes',
                      child: Text("Cliente", style: subtituloStyle(context)),
                      header: true,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return SignInClient();
                        },
                      ));
                    },
                  ),
                ),

                SizedBox(
                  width: 200, 
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: Size(24, 24),
                      padding: EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Semantics(
                      label: 'Ir a inicio de sesión administradores y agentes',
                      child: Text("Administración", style: subtituloStyle(context)),
                      header: true,
                    ),
                    
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return SignInAgent();
                        },
                      ));
                    },
                  ),
                ),

                
              ],
            )
            : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                SizedBox(
                  width: 200, 
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(24, 24),
                      backgroundColor: Colors.amber,
                      padding: EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Semantics(
                      child: Text("Cliente", style: subtituloStyle(context)),
                      header: true,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return SignInClient();
                        },
                      ));
                    },
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: 200, 
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(24, 24),
                      backgroundColor: Colors.amber,
                      padding: EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Semantics(
                      child: Text("Administración", style: subtituloStyle(context)),
                      header: true,
                    ),                    
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return SignInAgent();
                        },
                      ));
                    },
                  ),
                ),

                
              ],
            ),
            SizedBox(width: 10,),
            
          ],
        ),
      ),
    );
  }
}