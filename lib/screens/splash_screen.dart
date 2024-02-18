import 'package:airecruit/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:airecruit/screens/login_screen.dart';
import 'package:flutter/material.dart';
//
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay before navigating to the next screen
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            color: Color.fromARGB(255, 239, 91, 17),
          ),
          // Logo and tagline
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('Assets/logo.png'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your Ai-Recruiter\ Assistant',
                style: TextStyle(
                  color: Color(0xFFFFFFFF), // Changed color
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          // Progress indicator
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 30),
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFFFFFFF)), // Changed color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
