import 'dart:convert';

import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';


Future<dynamic> userAuth(String username, String password) async{
  Map body = {
    
    "username": username,
    //"email": "",
    "password": password

  };
  var url = Uri.parse("$baseUrl/user/auth/login/");
  var res = await http.post(url,body: body);

  print(res.body);
  print(res.statusCode);
  if(res.statusCode == 200){
    Map json = jsonDecode(res.body);
    String token = json['key'];
    var box = await Hive.openBox(tokenBox);
    box.put("token", token);
    User ? user = await getUser(token);
    return user;
  }
  else{
    Map json = jsonDecode(res.body);
    print(json);
    if (json.containsKey("username")){
      return json["username"][0];
    }
    if (json.containsKey("password")){
      return json["password"][0];
    }
    if (json.containsKey("non_field_errors")){
      return ["non_field_errors"][0];
    }
  }
}

Future<User?> getUser(String token) async {
  var url = Uri.parse("$baseUrl/user/auth/user/");
  var res = await http.get(url,headers: {
      'Authorization': 'Token $token',
  });
  //print(res.body);
  if(res.statusCode == 200){
    var json = jsonDecode(res.body);

    User user = User.fromJson(json);
    user.token = token;
    return user;
  }
  else{
    return null;
  }
  
  //print(res.statusCode);
}

//{"key":"a2123bb2c65d4b46b7f72d66a72db708fccf6ef6"}


Future<dynamic> registerUser(String username,String email,String password,String confirmPasswd) async {
  Map<String, dynamic> data = {
    "username": username,
    "email": email,
    "password1": password,
    "password2": confirmPasswd,
  };

  var url = Uri.parse("localhost:8000/user/auth/registration/");
  var res = await http.post(url,body: data);
  //print(res.body);
  if(res.statusCode == 200 || res.statusCode == 201){
    Map json = jsonDecode(res.body);

    if(json.containsKey("key")){
      String token = json["key"];
      var a= await getUser(token);
      if (a != null){
        User user = a;
        return user;
      }
      else{
        return null;
      } 
    }
    
  }
  else if (res.statusCode == 400){
     Map json = jsonDecode(res.body);
    if(json.containsKey("username")){
      return json["username"][0];
    } else if(json.containsKey("password")){
      return json["password"][0];
    }
  }
  else{
    print(res.body);
    print(res.statusCode);
    return null;
  }
  
  //print(res.statusCode);
}

Future<List<Ticket>> getTickets(String token) async {
  List<Ticket> tickets = [];
  var url = Uri.parse("http://localhost:8000/user/getTicket");
  var res = await http.get(url, headers: {
    'Authorization': 'Token $token',
  });
  
  if (res.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(res.body);
    // Accede a la clave "data" para obtener la lista de tickets
    final List<dynamic> ticketData = jsonData['data'];
    // Mapea los datos de los tickets a objetos Ticket
    tickets = ticketData.map((item) => Ticket.fromJson(item)).toList(); 
    return tickets;
  } else {
    throw Exception('Failed to load tickets');
  }
}



Future<bool?> sendForm(String tit, String desc, String sol) async {
  bool sent = false;
  Map<String, dynamic> data = {
    "titulo": tit,
    "descripcion": desc,
    "solicitante": sol,
  };
  String jsonData = jsonEncode(data);
  var url = Uri.parse("http://localhost:8000/user/centaurApp/");
  try {
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Specify the content type as JSON
      },
      body: jsonData, // Pass the JSON data as the request body
    );

    // Check the response status code
    if (response.statusCode == 200 || response.statusCode == 500) {
      // Request was successful, handle the response data here
      print('POST request successful');
      print('Response: ${response.body}');
      sent = true;
    } else {
      // Request failed
      print('POST request failed with status: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (error) {
    // Handle any errors that occurred during the request
    print('Error making POST request: $error');
  }
  return sent;
}

Future<bool> modifyTicket(int ident, String tit, String desc, String token) async {
  Map<String, dynamic> data = {
    "id": ident,
    "titulo": tit,
    "descripcion": desc,
  };
  String jsonData = jsonEncode(data);

  var url = Uri.parse('http://localhost:8000/user/updateTicket/');
  
  try {
    http.Response response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token', // Incluye el token de autenticación en el encabezado
      },
      body: jsonData,
    );
    
    if (response.statusCode == 200) {
      // La solicitud fue exitosa
      print('PUT request successful');
      print('Response: ${response.body}');
      return true;
    } else {
      // La solicitud falló
      print('PUT request failed with status: ${response.statusCode}');
      print('Response: ${response.body}');
      return false;
    }
  } catch (error) {
    // Manejar cualquier error que ocurra durante la solicitud
    print('Error making PUT request: $error');
    return false;
  }
}

Future<bool> enviarDatosAlFormulario(String titulo, String descripcion, List<Widget> campos) async {
  bool hecho = false;
  final Map<String, dynamic> datos = {
    'titulo': titulo,
    'descripcion': descripcion,
    'campos': [],
  };

  for (Widget campo in campos) {
    if (campo is TextField) {
      datos['campos'].add({
        'tipo': 'Texto',
        'nombre': (campo as TextField).controller?.text,
      });
    } else if (campo is Column && campo.children.length == 2) {
      final fieldName = (campo.children.first as Text).data;
      final List<String> opciones = [];
      for (var i = 1; i < campo.children.length; i++) {
        final String opcion = (campo.children[i] as DropdownButton<String>).value!;
        opciones.add(opcion);
      }
      datos['campos'].add({
        'tipo': 'Desplegable',
        'nombre': fieldName,
        'opciones': opciones,
      });
    }
  }

  final String apiUrl = 'http://localhost:8000/user/createForm/';
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tokenBox}' // Agrega el token de autenticación aquí
    },
    body: json.encode(datos),
  );

  if (response.statusCode == 201) {
    print('Formulario creado exitosamente');
    hecho = true;
  } else {
    print('Error al crear el formulario: ${response.body}');
  }
  return hecho;
}


Future<List<Ticket>> getForm(String token) async {
  List<Ticket> tickets = [];
  var url = Uri.parse("http://localhost:8000/user/getTicket");
  var res = await http.get(url, headers: {
    'Authorization': 'Token $token',
  });
  
  if (res.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(res.body);
    // Accede a la clave "data" para obtener la lista de tickets
    final List<dynamic> ticketData = jsonData['data'];
    // Mapea los datos de los tickets a objetos Ticket
    tickets = ticketData.map((item) => Ticket.fromJson(item)).toList(); 
    return tickets;
  } else {
    throw Exception('Failed to load tickets');
  }
}