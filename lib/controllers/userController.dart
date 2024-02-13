import 'package:airecruit/models/User.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserController extends ChangeNotifier {
  User? _currentUser;
  List<User> _users = [];

  User? get currentUser => _currentUser;
  List<User> get users => _users;

  
  Future<void> loginUser(String username, String password) async {
    final response = await http.get(
      Uri.parse('http://192.168.33.1:5000/signin/$username/$password'),
    );

    if (response.statusCode == 200) {
      bool loginResult = jsonDecode(response.body);

      if (loginResult) {
        // Navigate to the next screen or perform desired action on successful login
        print('Login successful');
      } else {
        // Show an error message or handle accordingly on login failure
        print('Login failed');
      }
    } else {
      // Handle HTTP error
      print('Error: ${response.statusCode}');
    }
  }



Future<void> signupUser(String username, String email, String password) async {
  try {
    // URL
    Uri addUri = Uri.parse("http://127.0.0.1:5000/signup");

    // Data à envoyer
    Map<String, dynamic> userObject = {
      "email": email,
      "username": username,
      "password": password
    };

    // Headers
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Requête HTTP
    final response = await http.post(addUri, headers: headers, body: json.encode(userObject));

    // Vérification de la réponse
    if (response.statusCode == 200) {
      print("Inscription réussie");
    } else if (response.statusCode == 401) {
      print("Problème côté client");
    } else {
      print("Problème côté serveur");
    }
  } catch (e) {
    // Gestion des erreurs
    print("Une erreur s'est produite lors de la tentative d'inscription : $e");
  }
}


}