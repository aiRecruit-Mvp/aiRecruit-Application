import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../providers/userprovider.dart';
import '../screens/home_screen.dart';
import '../screens/signup_screen.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class AuthService {

  void signUpUser({
    required BuildContext context,
    required String email,
    required String name,
    required String password,
    required File imageFile, // Add an argument for the image file
  }) async {
    try {
      Uri uri = Uri.parse('${Constants.uri}/signup');
      http.MultipartRequest request = http.MultipartRequest('POST', uri)
        ..fields['email'] = email
        ..fields['name'] = name
        ..fields['password'] = password
        ..files.add(await http.MultipartFile.fromPath(
          'file', // This 'file' key must match the key expected on the server
          imageFile.path,
          contentType: MediaType('image', basename(imageFile.path).split('.').last),
        ));

      http.StreamedResponse res = await request.send();

      if (res.statusCode == 201) {
        // Handle success
        showSnackBar(context, 'Account created login with the same credentials');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/signin'),
        // alternate method to do this M2
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8"
        },
      );
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          userProvider.setUser(jsonDecode(res.body)); // Pass decoded JSON map

          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);

          navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  void getUserData(BuildContext context) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      var tokenRes = await http.post(
        Uri.parse('${Constants.uri}/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8",
          'x-auth-token': token!
        },
      );
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${Constants.uri}/'),
          headers: <String, String>{
            'Content-Type': "application/json; charset=UTF-8",
            'x-auth-token': token
          },
        );
        userProvider.setUser(jsonDecode(userRes.body)); // Pass decoded JSON map
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
    navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SignupScreen(),
        ),
        (route) => false);
  }

  void forgotPassword(
      {required BuildContext context, required String email}) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      // Set the email in the UserProvider
      userProvider.setPasswordResetEmail(email);

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/forgot_password'),
        body: jsonEncode({'email': email}),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8",
        },
      );
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Password reset email sent successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void verifyCode(
      {required BuildContext context,
      required String code,
      required String email}) async {
    try {
      // Get the email from the UserProvider
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      email = userProvider.user.email;
      if (email.isEmpty) {
        showSnackBar(context, 'Email address not found');
        return;
      }

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/verify_code'),
        body: jsonEncode({'email': email, 'code': code}),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8",
        },
      );
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Verification code is valid');
          // Navigate to change password screen or perform desired action
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void changePassword(
      {required BuildContext context,
      required String newPassword,
      required String email}) async {
    try {
      // Get the email from the UserProvider
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      email = userProvider.user.email;
      if (email.isEmpty) {
        showSnackBar(context, 'Email address not found');
        return;
      }

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/reset_password'),
        body: jsonEncode({'email': email, 'new_password': newPassword}),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8",
        },
      );
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Password successfully changed');
          // Navigate to login screen or perform desired action
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
