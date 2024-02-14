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
import '../screens/setpassword_screen.dart';
import '../screens/signup_screen.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class AuthService {

  void signUpUser({
    required BuildContext context,
    required String email,
    required String name,
    required String password,
    required File imageFile, // Ensure this is the File from dart:io
  }) async {
    try {
      Uri uri = Uri.parse('${Constants.uri}/signup');
      http.MultipartRequest request = http.MultipartRequest('POST', uri)
        ..fields['email'] = email
        ..fields['name'] = name
        ..fields['password'] = password

        ..files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: MediaType('file', basename(imageFile.path).split('.').last),
        ));

      http.StreamedResponse res = await request.send();

      if (res.statusCode == 201) {
        // Handle success
        showSnackBar(context, 'Account created login with the same credentials');
      } else {
        // Handle error
        showSnackBar(context, 'Failed to create account');
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
        userProvider.setUser(jsonDecode(userRes.body));
        //print(object)// Pass decoded JSON map
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

  Future<int> verifyCode(
      {required BuildContext context,
        required String code,
        required String email}) async {
    try {
      // Get the email from the UserProvider
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      email = userProvider.user.email;
      if (email.isEmpty) {
        showSnackBar(context, 'Email address not found');
        return 400; // Return 400 if email is empty
      }

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/verify_code'),
        body: jsonEncode({'email': email, 'code': code}),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8",
        },
      );

      if (res.statusCode == 200) {
        showSnackBar(context, 'Verification code is valid');
        return 200; // Return 200 if verification is successful
      } else {
        return 400; // Return 400 if verification fails
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return 400; // Return 400 if an error occurs
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
  void setPassword(
      {required BuildContext context,
        required String newPassword,
        required String email}) async {
    try {


      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/set-password'),
        body: jsonEncode({'email': email, 'password': newPassword}),
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

  Future<void> sendGoogleSignInDataToBackend(String code, BuildContext context) async {
    final Uri uri = Uri.parse('${Constants.uri}/google-sign-in');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'code': code}),
      );

      if (response.statusCode == 200) {
        print('Google Sign-In data sent to /home endpoint successfully');
        final responseBody = json.decode(response.body);

        // Assuming 'user_id' is an object and you need the '_id' field from it
        if (responseBody['user_id'] != null && responseBody['user_id'] is Map<String, dynamic>) {
          final userId = responseBody['user_id']['email']; // Extract the '_id' as the userId
         print("Extracted userId: $userId");

          // Navigate to SetPasswordScreen with userId
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SetPasswordScreen(userId: userId)),
          );
        } else {
          print("The 'user_id' key is not present or not in the expected format.");
        }
      } else {
        print('Error sending Google Sign-In data to /home endpoint: ${response.statusCode}');
        // Handle other error responses
      }
    } catch (error) {
      print('Error sending Google Sign-In data to /home endpoint: $error');
      // Handle error
    }
  }

}



