import 'package:airecruit/screens/otp_screen.dart';
import 'package:airecruit/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:airecruit/screens/signup_screen.dart';
import 'package:airecruit/screens/login_scren.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
       initialRoute: '/signup', // Set the initial route
      getPages: [
        //GetPage(name: '/splash', page: () => SplashScreen()), // Define the SplashScreen route
        GetPage(name: '/signup', page: () => SignUp()), // Define the SignUp route
        GetPage(name: '/signin', page: () => Login()), // Define the SignUp route
        GetPage(name: '/otp', page: () => Otp()), // Define the SignUp route


      ],
    );
  }
}

