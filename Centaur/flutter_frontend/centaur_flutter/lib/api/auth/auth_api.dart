import 'dart:convert';

import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/formulario_model.dart';
import 'package:centaur_flutter/models/tarea_model.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'package:intl/intl.dart';


Future<dynamic> userAuth(String username, String password) async{
  Map body = {
    
    "username": username,
    //"email": "",
    "password": password

  };
  var url = Uri.parse("http://localhost:8000/user/api-token-auth/");
  var res = await http.post(
    url,
    headers: {
      "Content-Type": "application/json"
    },
    body: jsonEncode(body),
  );

  print(res.body);
  print(res.statusCode);

  if(res.statusCode == 200){
    Map<String, dynamic> json = jsonDecode(res.body);
    print('JSON!!!!:${json}');
    String token = json['token'];
    var box = await Hive.openBox('tokenBox');
    box.put("token", token);
    User? user = await getUser(token);
    if (user != null) {
      user.token = token;
      List<dynamic> groupsJson = json['user']['groups'] ?? [];
      List<String> groupNames = groupsJson.map((group) => group['name'].toString()).toList();
      user.groups = groupNames;
    }
    //print("USER!!!!!: ${user?.groups?.toString()}");
    return user;
  }
  else{
    Map<String, dynamic> json = jsonDecode(res.body);
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
    Map<String, dynamic> json = jsonDecode(res.body);
    User user = User.fromJson(json);
    return user;
  }
  else{
    return null;
  }
  
  //print(res.statusCode);
}




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
    final List<dynamic> ticketData = jsonData['data'];
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
        'Content-Type': 'application/json',
      },
      body: jsonData, 
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

Future<bool> enviarDatosAlFormulario(String titulo, String descripcion, List<Campo> campos) async {
  bool hecho = false;
  final Map <String, dynamic> datos={
    'titulo': titulo,
    'descripcion': descripcion,
    'campos': [],
  };
  print(campos);
  for (Campo campo in campos) {
    if (campo.tipo == 'Texto') {
      datos['campos'].add({
        'tipo': 'Texto',
        'nombre': campo.nombre,
      });
    } else if (campo.tipo == 'Desplegable') {
      final List<String> opciones = [];

      if (campo.opciones != null) {
        for (Opcion opcion in campo.opciones!) {
          opciones.add(opcion.nombre);
}
      }

      datos['campos'].add({
        'tipo': 'Desplegable',
        'nombre': campo.nombre,
        'opciones': opciones,
      });
    }
  }

  final String apiUrl = 'http://localhost:8000/user/createForm/';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tokenBox}',
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

Future<List<Formulario>> obtenerFormularios() async {
  final String apiUrl = 'http://localhost:8000/user/getForm/';
  final response = await http.get(Uri.parse(apiUrl));
  print('CONTENIDO: ${response.body}');
  print('ESTADO: ${response.statusCode}');
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List<dynamic> formData = jsonData['data'];
    final List<Formulario> formularios = formData.map((data) => Formulario.fromJson(data)).toList();
    return formularios;
  } else {
    print('Error al obtener los formularios: ${response.body}');
    return [];
  }
}

Future<bool> crearTarea(String titulo, String descripcion, String ? creador, DateTime fecha_ini, DateTime hora_ini, DateTime fecha_fin, DateTime hora_fin) async {
  String formattedFechaIni = DateFormat('yyyy-MM-dd').format(fecha_ini);
  String formattedFechaFin = DateFormat('yyyy-MM-dd').format(fecha_fin);

  // Format time strings in 'HH:mm:ss' format
  String formattedHoraIni = DateFormat('HH:mm:ss').format(hora_ini);
  String formattedHoraFin = DateFormat('HH:mm:ss').format(hora_fin);
  final Map<String, dynamic> datos = {
    'titulo': titulo,
    'descripcion': descripcion,
    'creador' : creador,
    'fecha_ini': formattedFechaIni, // Convert DateTime to ISO 8601 string
    'hora_ini': formattedHoraIni,
    'fecha_fin': formattedFechaFin,
    'hora_fin': formattedHoraFin,
  };

  final String apiUrl = 'http://localhost:8000/user/crearTarea/';
  bool hecho = false;
  
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tokenBox}', // Ensure tokenBox is defined and contains a valid token
      },
      body: json.encode(datos),
    );

    if (response.statusCode == 201) {
      print('Tarea creada exitosamente');
      hecho = true;
      return hecho;
    } else {
      print('Error al crear la tarea: ${response.body}');
      // Handle other status codes if needed
      throw Exception('Error al crear la tarea: ${response.body}');
    }
  } catch (e) {
    print('Error inesperado: $e');
    // Handle unexpected errors
    throw Exception('Error inesperado al crear la tarea');
  }
}

Future<List<Tarea>> obtenerTareas() async {
  final String apiUrl = 'http://localhost:8000/user/getTarea';
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List<dynamic> TareaData = jsonData['data'];
    final List<Tarea> tareas = TareaData.map((data) => Tarea.fromJson(data)).toList();
    return tareas;
  } else {
    print('Error al obtener los formularios: ${response.body}');
    return [];
  }
}

Future<bool> logout() async {
  final String apiUrl = 'http://localhost:8000/user/auth/logout/';
  bool logged_out = false;
  // Send POST request to log out
  final response = await http.post(
    Uri.parse(apiUrl),
    // You may need to include any required headers here, such as authentication tokens
  );

  // Check if the request was successful
  if (response.statusCode == 200) {
    // Log out was successful
    print('Logged out successfully');
    logged_out = true;
    return logged_out;
  } else {
    // Log out failed, handle error
    print('Failed to log out. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    return logged_out;
  }
}

Future <bool> editarVisibilidad(Formulario form) async {
  Map<String, dynamic> data = {
    'oculto' : !form.oculto
  };
  String jsonData = jsonEncode(data);

  var url = Uri.parse('http://localhost:8000/user/updateForm/');
  
  try {
    http.Response response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tokenBox}',
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