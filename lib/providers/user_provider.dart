import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _email = '';
  String _password = '';

  String get email => _email;
  String get password => _password;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    print(password);
    notifyListeners();
  }

  void loginUser(String email, String password) {
    // Perform login logic here
    // After login, you can notify listeners to update any widgets that depend on the login state
    notifyListeners();
  }
}
