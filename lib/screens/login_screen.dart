import 'package:airecruit/controllers/userController.dart';
import 'package:airecruit/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:airecruit/screens/signup_screen.dart';
import 'package:airecruit/utils/globalColors.dart';


void main() {
  runApp(Login());
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserController userController = UserController();
  final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
      '104792978938-8osg03385fiif0h9n084j2raadlacgsv.apps.googleusercontent.com',
      scopes: ['email']);

      void _goToSignUpPage() {
    Get.to(SignUp());
     
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("ai-Recruit"),
        ),
        body: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Join ai-Recruit Today",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 239, 91, 17)),
                ),
                SizedBox(height: 20),
                Text(
                  "Unlock Your Professional Career!",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 40),
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
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.visibility),
                        color: Color.fromARGB(255, 239, 91, 17),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.7,
                      child: Checkbox(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ),
                    Text("Remember me"),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: ElevatedButton(
                          onPressed: () {
                            userController.loginUser(
                              emailController.text,
                              passwordController.text,
                            );
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
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Doesn't have an account? "),
                     InkWell(
                        onTap: _goToSignUpPage, // Call the function to navigate to the sign-in page
                        child: Text(
                            'Sign Up',
                             style: TextStyle(
                             color: GlobalColors.primaryColor,
                             fontWeight: FontWeight.bold,
                             ),
                            ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.apple),
                    ),
                    IconButton(
                      onPressed: () {
                        // Perform LinkedIn Sign-In
                        //signInWithLinkedIn();
                      },
                      icon: Icon(Icons.facebook),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.branding_watermark),
                    ),
                    IconButton(
                      onPressed: () async {
                        // Perform Google Sign-In
                        try {
                          await _handleSignIn();
                        } catch (error) {
                          print('Error during Google Sign-In: $error');
                        }
                      },
                      icon: FaIcon(FontAwesomeIcons.google),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        // Send Google Sign-In data to the backend
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final String? code = googleAuth.idToken;

        if (code != null) {
          await userController.sendGoogleSignInDataToBackend(code);
        }
      }
    } catch (error) {
      print('Error during Google Sign-In: $error');
    }
  }

// Future<void> signInWithLinkedIn() async {
//   // Call the signInWithLinkedIn function from your user controller
//   await userController.signInWithLinkedIn();
// }
}