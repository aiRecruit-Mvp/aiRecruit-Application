import 'package:airecruit/models/User.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserController extends ChangeNotifier {
  User? _currentUser;
  List<User> _users = [];

  User? get currentUser => _currentUser;
  List<User> get users => _users;

   Future<void> signupUser(
    String username, String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('http://172.16.1.94:5000/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      print('User signup successful');
      // You may update the UI or perform other actions on successful signup
    } else {
      print('Error: ${response.statusCode}');
      // Handle signup failure
    }
  } catch (e) {
    print('Error during signup: $e');
    // Handle network or other exceptions
  }
}
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
  Future<void> sendGoogleSignInDataToBackend(String code) async {
    final Uri uri = Uri.parse('http://127.0.0.1:5000/google-sign-in');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'code': code}),
      );

      if (response.statusCode == 200) {
        print('Google Sign-In data sent to /home endpoint successfully');
        // Handle success
      } else {
        print(
            'Error sending Google Sign-In data to /home endpoint: ${response.statusCode}');
        // Handle other error responses
      }
    } catch (error) {
      print('Error sending Google Sign-In data to /home endpoint: $error');
      // Handle error
    }
  }


}
