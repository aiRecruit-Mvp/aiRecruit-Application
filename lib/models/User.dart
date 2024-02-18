import 'dart:convert';

class User {
  final String id;
  final String name;
  String email;
  final String token;
  final String password;
  final String profilePicturePath;


  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.password,
    required this.profilePicturePath,
  });



  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'token': token,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
      password: map['password'] ?? '',
      profilePicturePath: map['file'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['user']['name'] ?? '',
      email: json['user']['email'] ?? '',
      token: json['token'] ?? '',
      password: json['user']['password'] ?? '',
      profilePicturePath: json['user']['file'] ?? '',
    );
  }
}
