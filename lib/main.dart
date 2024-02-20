import 'package:airecruit/providers/userprovider.dart';
import 'package:airecruit/screens/ApplicationForm.dart';
import 'package:airecruit/screens/home_screen.dart';
import 'package:airecruit/screens/signup_screen.dart';
import 'package:airecruit/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:airecruit/screens/JobApplicationState.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authService.getUserData(context);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(),
        home: Provider.of<UserProvider>(context).user.token.isEmpty
            ? ApplicationForm()
            : HomeScreen());
  }
}
