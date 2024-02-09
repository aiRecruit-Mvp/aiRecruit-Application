import 'package:airecruit/controllers/userController.dart';
import 'package:airecruit/screens/forgotPassword_scren.dart';
import 'package:airecruit/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

void main() {
  runApp(Login());
}

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'images/logo.png',
          width: 80,
          height: 100,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your existing widgets...
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // More widgets...
            ElevatedButton(
              onPressed: () {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                userProvider.loginUser(emailController.text, passwordController.text);
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 239, 91, 17),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text("Log in"),
            ),
            // Remaining widgets...
          ],
        ),
      ),
    );
  }
}

