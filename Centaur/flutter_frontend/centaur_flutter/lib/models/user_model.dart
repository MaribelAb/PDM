import 'dart:convert';

class User{
  int ? id;
  String ? token;
  String ? username;
  String ? email;
  List<String>? groups;


  User({
    this.username,
    this.email,
    this.groups,
    this.id,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<dynamic> groupsJson = json['groups'] ?? [];
    List<String> groupNames = groupsJson.map((group) => group['name'].toString()).toList();

    return User(
      id: json['id'],
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      groups: groupNames,
    );
  }

 
}

