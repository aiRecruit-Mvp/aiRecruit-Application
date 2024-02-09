import 'package:airecruit/screens/login_scren.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airecruit/providers/user_provider.dart'; // Import your user provider
import 'screens/login_scren.dart'; // Import your screens as needed

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<UserProvider>(
      create: (_) => UserProvider(),
      child: MaterialApp(
        home: Login(),
      ),
    );
  }
}


