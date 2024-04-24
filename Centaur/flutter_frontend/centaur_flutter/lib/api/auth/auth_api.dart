import 'dart:convert';

import 'package:centaur_flutter/constants.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:centaur_flutter/models/user_model.dart';
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

Future<Ticket?> getTicket(String token) async {
  var url = Uri.parse("http://localhost:8000/admin/centaurApp/ticket/");
  var res = await http.get(url,headers: {
      'Authorization': 'Token $token',
  });
  //print(res.body);
  if(res.statusCode == 200){
    var json = jsonDecode(res.body);

    Ticket ticket = Ticket.fromJson(json);
    ticket.token = token;
    return ticket;
  }
  else{
    return null;
  }
  
  //print(res.statusCode);
}

Future<Ticket?> sendForm(String tit, String desc, String sol) async {
  
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
    if (response.statusCode == 200) {
      // Request was successful, handle the response data here
      print('POST request successful');
      print('Response: ${response.body}');
    } else {
      // Request failed
      print('POST request failed with status: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (error) {
    // Handle any errors that occurred during the request
    print('Error making POST request: $error');
  }
  
}
