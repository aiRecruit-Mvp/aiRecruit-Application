import 'package:airecruit/models/User.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:linkedin_login/linkedin_login.dart';


class UserController extends ChangeNotifier {
  User? _currentUser;
  List<User> _users = [];
  http.Client client;

  UserController() : client = http.Client();

  User? get currentUser => _currentUser;
  List<User> get users => _users;

  Future<void> signupUser(
      String username, String email, String password) async {
    final response = await client.post(
      Uri.parse('http:/192.168.33.1:5000/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'pwd': password,
      }),
    );

    if (response.statusCode == 200) {
      print('User signup successful');
      // You may update the UI or perform other actions on successful signup
    } else {
      print('Error: ${response.statusCode}');
      // Handle signup failure
    }
  }

  Future<void> loginUser(String username, String password) async {
    final response = await client.get(
      Uri.parse('https://192.168.33.1:5000/signin/$username/$password'),
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
    final Uri uri = Uri.parse('https://192.168.33.1:5000/google-sign-in');

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

  // Future<void> signInWithLinkedIn(BuildContext context) async {
  //   final LinkedInLoginResult linkedIn =
  //       await LinkedInLogin().logIn(context: context);

  //   if (linkedIn.status == LinkedInLoginStatus.error) {
  //     print('Error: ${linkedIn.errorMessage}');
  //     return;
  //   }

  //   if (linkedIn.status == LinkedInLoginStatus.success) {
  //     final accessToken = linkedIn.accessToken!.token;
  //     final linkedInId = linkedIn.user.id;
  //     final email = linkedIn.user.email;
  //     final name = linkedIn.user.displayName;

  //     // Send user data to your backend
  //     final response = await http.post(
  //       Uri.parse('https://your-backend-url.com/linkedin_signin'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'accessToken': accessToken,
  //         'linkedInId': linkedInId,
  //         'email': email,
  //         'name': name,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       print('LinkedIn sign-in successful');
  //     } else {
  //       print('Error: ${response.statusCode}');
  //     }
  //   }
  // }
}


