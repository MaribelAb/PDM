import 'package:centaur_flutter/pages/login_agente.dart';
import 'package:centaur_flutter/pages/login_cliente.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [ElevatedButton].

void main() {
  runApp(const IndexPage());
}

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Centaur';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: Column(
          
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset("images/logo_claro.png"),
              )
              ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("¿Quién eres?"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber,padding: EdgeInsets.only(top: 5,bottom: 5)),
                  child: Text("Cliente",style: TextStyle(color: Colors.black),),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context){
                        return SignInClient();
                      }
                    )
                    );
                  },
                ),
                
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber,padding: EdgeInsets.only(top: 5,bottom: 5)),
                  child: Text("Administración",style: TextStyle(color: Colors.black),),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context){
                        return SignInAgent();
                      }
                    )
                    );
                  },
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