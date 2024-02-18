import 'package:airecruit/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/constants.dart';
import 'login_screen.dart';

class SetPasswordScreen extends StatefulWidget {
  final String userId; // Assurez-vous de passer l'userId à cet écran

  SetPasswordScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();
  void changePassword(BuildContext context) {


    authService.setPassword(
      context: context,
      email: widget.userId ,
      newPassword: _passwordController.text,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Définir un Nouveau Mot de Passe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Nouveau Mot de Passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => changePassword(context),
              child: Text('Mettre à Jour le Mot de Passe'),
            ),
          ],
        ),
      ),
    );
  }
}
