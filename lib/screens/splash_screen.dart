import 'dart:async';

import 'package:airecruit/screens/login_scren.dart';
import 'package:airecruit/utils/globalColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () {
      Get.to(const Login());
    });
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: Center(
          child: Text(
        'Logo',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      )),
    );
  }
}
