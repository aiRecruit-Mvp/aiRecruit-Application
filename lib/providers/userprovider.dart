import 'package:airecruit/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(id: '', name: '', email: '', token: '', password: '', profilePicturePath: '');

  User get user => _user;

  void setUser(Map<String, dynamic> userMap) {
    _user = User.fromJson(userMap);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void setPasswordResetEmail(String email) {
    _user.email = email;
    notifyListeners();
  }
}
