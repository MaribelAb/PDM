class User{
  int ? id;
  String ? token;
  String ? username;
  String ? email, first_name, last_name;


  User({
    this.username,
    this.email,
    this.first_name,
    this.last_name,
    this.id,
  });

  factory User.fromJson(json){
    return User(
      email: json["email"],
      first_name: json["first_name"],
      last_name:json["last_name"],
      id: json["id"],
      username: json["username"],
    );
  }
}

